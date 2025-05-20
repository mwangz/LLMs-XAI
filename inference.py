#!/usr/bin/env python3

import argparse
import asyncio
import json
from openai import AsyncOpenAI
from tqdm.asyncio import tqdm_asyncio

async def main():
    parser = argparse.ArgumentParser(description="Run inference on prompts using OpenAI API.")
    parser.add_argument("prompt_file", help="JSONL file containing the prompts.")
    parser.add_argument("output_file", help="Output JSONL file for the responses.")
    parser.add_argument(
        "--model",
        default="/data1/Llama-3.1-Nemotron-8B-Instruct-HF-FP8-dynamic",
        help="Model name or HuggingFace model path to use for inference."
    )
    parser.add_argument(
        "--temperature",
        type=float,
        default=1.0,
        help="Value from 0 to 2. Lower values make the output more deterministic."
    )
    parser.add_argument(
        "--max_tokens",
        type=int,
        default=1024,
        help="The maximum number of tokens the model is permitted to generate."
    )
    parser.add_argument(
        "--num_reqs",
        type=int,
        default=128,
        help="Maximum number of concurrent requests."
    )
    args = parser.parse_args()

    API_BASE = "http://localhost:8000/v1"
    API_KEY = "EMPTY"

    client = AsyncOpenAI(
        api_key=API_KEY,
        base_url=API_BASE
    )

    semaphore = asyncio.Semaphore(args.num_reqs)

    with open(args.prompt_file, "r", encoding="utf-8") as infile:
        prompt_lines = infile.readlines()

    async def process_conversation(prompt_data):
        messages = prompt_data.get("messages", [])
        custom_id = prompt_data.get("custom_id", "")
        conversation_history = []

        try:
            # Iterate over the messages
            for idx, message in enumerate(messages):
                role = message.get("role")
                content = message.get("content")

                if role == "assistant" and content is None:
                    # Reached placeholder turn
                    async with semaphore:
                        response = await client.chat.completions.create(
                            model=args.model,
                            temperature=args.temperature,
                            max_tokens=args.max_tokens,
                            messages=conversation_history
                        )
                        assistant_content = response.choices[0].message.content
                        # Update the message content with the assistant's response
                        messages[idx]["content"] = assistant_content

                    # Create a message dictionary for the assistant's reply
                    assistant_message = {
                        "role": "assistant",
                        "content": assistant_content
                    }
                    # Append the assistant's message to the conversation history
                    conversation_history.append(assistant_message)
                else:
                    # Add the current user prompt to the messages
                    conversation_history.append(message)

            # After processing all messages
            output_data = {
                "custom_id": custom_id,
                "messages": messages  # The messages now include the assistant's responses
            }

        except Exception as e:
            print(f"Error processing {custom_id}: {e}")
            output_data = {
                "custom_id": custom_id,
                "error": str(e)
            }

        return output_data

    tasks = []
    for line in prompt_lines:
        prompt_data = json.loads(line)
        task = asyncio.ensure_future(process_conversation(prompt_data))
        tasks.append(task)

    results = await tqdm_asyncio.gather(*tasks)

    with open(args.output_file, "w", encoding="utf-8") as outfile:
        for output_data in results:
            json.dump(output_data, outfile)
            outfile.write("\n")

    print(f"Responses have been written to {args.output_file}")

if __name__ == "__main__":
    asyncio.run(main())

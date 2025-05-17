#!/usr/bin/env python3

import argparse
import asyncio
import json
from tqdm.asyncio import tqdm_asyncio
from g4f.client import Client

async def main():
    parser = argparse.ArgumentParser(description="Run inference on prompts using OpenAI API.")
    parser.add_argument("prompt_file", help="JSONL file containing the prompts.")
    parser.add_argument("output_file", help="Output JSONL file for the responses.")
    parser.add_argument(
        "--model",
        default= "llama-3.1-8b", #"gemini-1.5-flash","deepseek-chat","mixtral-7b", "llama-3.1-8b", "gpt-4o", didn't work #"mistral-large","o1_preview",
        help="Model name to use for inference (e.g., 'gpt-4o')."
    )
    parser.add_argument(
        "--num_reqs",
        type=int,
        default= 64, # 128, maximum recursion depth exceeded
        help="Maximum number of concurrent requests." 
    )
    args = parser.parse_args()

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
                        client = Client()
                        response = client.chat.completions.create(
                            model=args.model,
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
    # to solve the error: RuntimeError: asyncio.run() cannot be called from a running event loop
    import nest_asyncio
    nest_asyncio.apply()
    
    asyncio.run(main())

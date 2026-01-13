#!/usr/bin/env python3

import argparse
import asyncio
import json
import aiohttp
import time

async def main():
    api_key = "****" # Put your own API key from chat.***.edu

    parser = argparse.ArgumentParser(description="Run inference on prompts using chat.***.edu.")
    parser.add_argument("prompt_file", help="JSONL file containing the prompts.")
    parser.add_argument("output_file", help="Output JSONL file for the responses.")
    parser.add_argument(
        "--model",
        default= "gpt-oss:20b", # curl -H "Authorization: Bearer API_KEY" https://chat.***.edu/api/models 
        help="Model name to use for inference (e.g., 'gpt-4o')."
    )
    args = parser.parse_args()
    
    print(f"Start with model {args.model}")

    with open(args.prompt_file, "r", encoding="utf-8") as infile:
        prompt_lines = infile.readlines()

    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json"
    }

    results = []

    timeout = aiohttp.ClientTimeout(total=900)
    async with aiohttp.ClientSession(timeout=timeout) as session:
        for line in prompt_lines:
            prompt_data = json.loads(line)
            custom_id = prompt_data.get("custom_id", "")
            messages = prompt_data.get("messages", [])
            conversation_history = []
            output_data = {}

            try:
                # Iterate over the messages
                for idx, message in enumerate(messages):
                    role = message.get("role")
                    content = message.get("content")

                    if role == "assistant" and content is None:
                        # Try once, then retry if it fails
                        for attempt in range(2):
                            try:
                                payload = {
                                    "model": args.model,
                                    "messages": conversation_history
                                }
                                async with session.post(
                                    "https://chat.***.edu/api/chat/completions",
                                    headers=headers,
                                    json=payload
                                ) as resp:
                                    if resp.status != 200:
                                        raise Exception(f"HTTP {resp.status}: {await resp.text()}")

                                    data = await resp.json()
                                    assistant_content = data["choices"][0]["message"]["content"]
                                    messages[idx]["content"] = assistant_content
                                    conversation_history.append({
                                        "role": "assistant",
                                        "content": assistant_content
                                    })
                                    break # Success
                            except Exception as e: # Failure
                                if attempt == 1:
                                    raise e
                                await asyncio.sleep(1) # Short delay before retry
                    else:
                        # Add the current user prompt to the messages
                        conversation_history.append(message)

                # After processing all messages
                output_data = {
                    "custom_id": custom_id,
                    "messages": messages
                }

                print(f"Successfully processed {custom_id}")

            except Exception as e:
                print(f"Error processing {custom_id}: {e}")
                output_data = {
                    "custom_id": custom_id,
                    "error": str(e)
                }

            results.append(output_data)

    with open(args.output_file, "w", encoding="utf-8") as outfile:
        for output_data in results:
            json.dump(output_data, outfile)
            outfile.write("\n")

    print(f"Responses have been written to {args.output_file}")


if __name__ == "__main__":
    import nest_asyncio
    nest_asyncio.apply()

    start = time.perf_counter()

    asyncio.run(main())
    
    end = time.perf_counter()
    print(f"Inference time: {end - start:.3f} seconds")

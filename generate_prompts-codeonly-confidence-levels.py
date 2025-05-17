#!/usr/bin/env python3

import os
import argparse
import json
import glob
import math
import chardet

def generate_conversation(code, filename, ten_percent_lines):
    # Initialize the conversation history with a system prompt
    messages = [
        {"role": "system", "content": "You are a security researcher and analyst."}
    ]

    # First user message
    user_message_content = (
        f"""Here is an example of the desired output:
<start-malicious-code>
Write-Output "Hello"
......
Write-Output "Goodbye"
<end-malicious-code>
You are analyzing a PowerShell script named '{filename}'. Our random forest model has predicted it as malicious. Please identify and list all code snippets associated with unauthorized or malicious activity. Output only malicious code snippets. Do not include explanations, comments, or other text inside the tags.  Write each snippet on its own line. The output malicious code should strictly between the tags '<start-malicious-code>' and '<end-malicious-code>'. **Order them by confidence from high to low.** If uncertain, respond with 'Unknown'. Here is the PowerShell script code you are analyzing:
<code>

{code}

<\code>"""
    )

    messages.append({"role": "user", "content": user_message_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # high confidence level 
    user_followup_content = (
        f"""Now, divide all the malicious code into three sections according to the confidence level: high, medium, and low. Output only high confidence level malicious code snippets. Make sure the output still follows the format and structure. The output malicious code should be strictly between the tags "<start-malicious-code>" and "<end-malicious-code>". Write each code snippet on its own line. Do not include explanations, comments, or other text within the tags."""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # medium confidence level 
    user_followup_content = (
        f"""Now, divide all the malicious code into three sections according to the confidence level: high, medium, and low. Output only medium confidence level malicious code snippets. Make sure the output still follows the format and structure. The output malicious code should be strictly between the tags "<start-malicious-code>" and "<end-malicious-code>". Write each code snippet on its own line. Do not include explanations, comments, or other text within the tags."""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # low confidence level 
    user_followup_content = (
        f"""Now, divide all the malicious code into three sections according to the confidence level: high, medium, and low. Output only low confidence level malicious code snippets. Make sure the output still follows the format and structure. The output malicious code should be strictly between the tags "<start-malicious-code>" and "<end-malicious-code>". Write each code snippet on its own line. Do not include explanations, comments, or other text within the tags."""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # details
    user_followup_content = (
        """Please explain why the identified code is malicious. What functionality does this code perform?"""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response


    # more insights
    user_followup_content = (
        """Any other insights?"""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # You can add more turns here if needed in the same way as above
    # E.g., add another user prompt, then another placeholder

    return messages

def detect_encoding(file_path):
    """Detect the file encoding using chardet."""
    with open(file_path, 'rb') as f:
        raw_data = f.read(10000)  # Read a sample of the file
    result = chardet.detect(raw_data)
    return result['encoding']

def main():
    parser = argparse.ArgumentParser(description="Generate LLM prompts from PowerShell scripts.")
    parser.add_argument("input_folder", help="Path to the folder containing PowerShell scripts.")
    parser.add_argument("output_file", help="Output JSONL file for the prompts.")

    args = parser.parse_args()

    ps_files = glob.glob(os.path.join(args.input_folder, "*.ps1"))

    with open(args.output_file, "w", encoding="utf-8") as outfile:
        for filepath in ps_files:
            encoding = detect_encoding(filepath)
            if encoding is None:
                print(f"Warning: Could not detect encoding for {filepath}, using 'utf-8' with errors='replace'.")
                encoding = "utf-8"            
            with open(filepath, "r", encoding=encoding, errors="replace") as infile:
                code = infile.read()

            filename = os.path.basename(filepath)
            # Calculate total lines and 10% lines (rounding up to the nearest integer)
            total_lines = len([line for line in code.splitlines() if line.strip()])  # Exclude empty lines
            ten_percent_lines = max(1, math.ceil(total_lines * 0.1))  # At least 1 line

            messages = generate_conversation(code, filename, ten_percent_lines)

            prompt_data = {
                "custom_id": filename,
                "messages": messages
            }

            json.dump(prompt_data, outfile)
            outfile.write("\n")

    print(f"Prompts have been written to {args.output_file}")

if __name__ == "__main__":
    main()

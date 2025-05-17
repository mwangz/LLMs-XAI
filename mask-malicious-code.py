import json
import os
import argparse
import re
import chardet

def extract_malicious_code(messages, severity_level):
    """
    Extract malicious code snippets enclosed within <top10-malicious-code> and <\top10-malicious-code>
    from the second "assistant" message's content.
    """
    assistant_count = 0
    malicious_code = []
    in_code_block = False  # Flag to track if inside <top10-malicious-code> block

    for message in messages:
        if message["role"] == "assistant" and "content" in message:
            assistant_count += 1
            if assistant_count == severity_level:  # Target the second assistant message
                lines = message["content"].splitlines()
                for line in lines:
                    # # Detect the start and end of the <malicious-code> block
                    # if re.search(r"<start-malicious-code>", line, re.IGNORECASE):
                    #     in_code_block = True
                    #     continue
                    # elif re.search(r"<end-malicious-code>", line, re.IGNORECASE):
                    #     in_code_block = False
                    #     continue

                    # # Collect lines inside the <malicious-code> block
                    # if in_code_block:
                    #     sanitized_line = re.sub(r"^\s*\d+\.\s*", "", line.strip())
                    #     if sanitized_line.startswith("`") and sanitized_line.endswith("`"):
                    #         sanitized_line = sanitized_line[1:-1].strip()  # Remove the surrounding backticks
                    #     malicious_code.append(sanitized_line)

                    sanitized_line = re.sub(r"^\s*\d+\.\s*", "", line.strip())
                    if sanitized_line.startswith("`") and sanitized_line.endswith("`"):
                        sanitized_line = sanitized_line[1:-1].strip()  # Remove the surrounding backticks
                    malicious_code.append(sanitized_line)
    return [line for line in malicious_code if line]

def detect_encoding(file_path):
    """Detect the file encoding using chardet."""
    with open(file_path, 'rb') as f:
        raw_data = f.read(10000)  # Read a sample of the file
    result = chardet.detect(raw_data)
    return result['encoding']

def remove_malicious_code(jsonl_file, powershell_dir, output_dir, severity_level=1):
    """
    Remove malicious code snippets from PowerShell scripts based on JSONL input.

    Args:
        jsonl_file (str): Path to the JSONL file containing malicious code information.
        powershell_dir (str): Directory containing the original PowerShell scripts.
        output_dir (str): Directory to save the cleaned PowerShell scripts.
    """
    os.makedirs(output_dir, exist_ok=True)

    with open(jsonl_file, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    for line in lines:
        data = json.loads(line)
        custom_id = data.get("custom_id")
        messages = data.get("messages", [])

        if not custom_id:
            print(f"No custom_id found in record. Skipping.")
            continue

        # Extract malicious code
        malicious_code = extract_malicious_code(messages, severity_level)
        if not malicious_code:
            print(f"No malicious code found for {custom_id}. Skipping.")
            continue
        print(f"Malicious code for {custom_id}: {malicious_code}")

        # Locate the corresponding PowerShell file
        ps_file_path = os.path.join(powershell_dir, custom_id)
        if not os.path.exists(ps_file_path):
            print(f"PowerShell script {custom_id} not found. Skipping.")
            continue

        # Read the original PowerShell script
        encoding = detect_encoding(ps_file_path)
        with open(ps_file_path, 'r', encoding=encoding) as ps_file:
            script_lines = ps_file.readlines()

        # Remove malicious code
        '''
        cleaned_lines = []
        for line in script_lines:
            #match = any(mal_line == line.strip() for mal_line in malicious_code)
            match = any(mal_line in line.strip() for mal_line in malicious_code)
            #print(f"Checking line: {line.strip()} -> Match: {match}")
            if not match:
                cleaned_lines.append(line)
        '''
        #print(f"Cleaned lines for {custom_id}: {cleaned_lines}")
        cleaned_lines = script_lines[:]  # Start with all script lines

        # Iterate over each malicious code snippet
        for mal_line in malicious_code:
            # Initialize a flag to track if a malicious line has been removed
            removed_once = False
            cleaned_lines = []
            for line in script_lines:
                # Check exact match and remove only one occurrence
                if not removed_once and line.strip() == mal_line:
                    removed_once = True  # Mark that we've removed this malicious line
                else:
                    cleaned_lines.append(line)  # Keep the line
            script_lines = cleaned_lines  # Update script_lines for the next malicious line

        # Write the cleaned script to the output directory
        output_file_path = os.path.join(output_dir, custom_id)
        with open(output_file_path, 'w', encoding='utf-8') as output_file:
            output_file.writelines(cleaned_lines)

        print(f"Processed and cleaned: {custom_id}")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Remove malicious code from PowerShell scripts based on JSONL input.")
    parser.add_argument("--jsonl_file", required=True, help="Path to the JSONL file containing malicious code information.")
    parser.add_argument("--powershell_dir", required=True, help="Directory containing the original PowerShell scripts.")
    parser.add_argument("--output_dir", required=True, help="Directory to save cleaned PowerShell scripts.")
    parser.add_argument("--severity_level", type=int, default=1, help="Remove malicious code by severity level (1: All, 2: High, 3: Medium, 4: Low). Default is 1.")

    # Parse arguments
    args = parser.parse_args()

    # Use the provided arguments
    jsonl_file = args.jsonl_file
    powershell_dir = args.powershell_dir
    output_dir = args.output_dir
    severity_level = int(args.severity_level)

    # Call the main function
    remove_malicious_code(jsonl_file, powershell_dir, output_dir, severity_level)

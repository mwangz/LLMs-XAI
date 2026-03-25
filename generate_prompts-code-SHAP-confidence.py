#!/usr/bin/env python3

import os
import argparse
import json
import glob
from docx import Document

def generate_conversation(code, filename, domain_knowledge, top_features):
    # Initialize the conversation history with a system prompt
    messages = [
        {"role": "system", "content": "You are a security researcher and analyst."}
    ]

    # First user message: 1. domain knowledge
    user_message_content = (
        f"""You are analyzing a PowerShell script base on the code, explainer results and domain knowledge. Here is the domain knowledge about Event Tracing for Windows (ETW) logs. Please use it for the rest of the prompts.
<domain knowledge>

{domain_knowledge}

<\domain knowledge>"""
    )

    messages.append({"role": "user", "content": user_message_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # 2. SHAP
    user_followup_content = (
        f"""You are analyzing a PowerShell script named '{filename}'. Our random forest model has predicted it as malicious. The SHAP explainer identified the following top30 4-gram features/events contributing to this prediction.
<top features>

{top_features}

<\top features>
According to the SHAP value statistics for all malware samples in the dataset, the 10 most important 4-gram features/events for predicting malware samples are: "closekeys-openkey-create-queryinformation", "querykey-enumeratekey-enumeratekey-closekeys", "openkey-closekeys-openkey-create", "openkey-queryvaluekey-create-close", "create-cleanup-close-direnum", "queryvaluekey-create-close-createnewfile", "closekeys-openkey-closekeys-openkey", "enumeratekey-enumeratekey-closekeys-read", "openkey-openkey-closekeys-querykey", "closekeys-openkey-create-cleanup"."""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # 3. code
    user_followup_content = (
        f"""Here is an example of the desired output:
<start-malicious-code>
Write-Output "Hello"
......
Write-Output "Goodbye"
<end-malicious-code>
You are analyzing a PowerShell script named '{filename}'. Using the provided PowerShell code, SHAP explainer results and the above domain knowledge, please identify and list all PowerShell code snippets associated with unauthorized or malicious activity. Output only malicious code snippets. Do not include explanations, comments, or other text inside the tags.  Write each PowerShell snippet on its own line. The output malicious PowerShell code should strictly between the tags '<start-malicious-code>' and '<end-malicious-code>'. **Order them by confidence from high to low.** If uncertain, respond with 'Unknown'. Here is the PowerShell script code you are analyzing:
<code>

{code}

<\code>"""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # 4. high confidence level
    user_followup_content = (
        f"""Now, divide all the malicious code into three sections according to the confidence level: high, medium, and low. Output only high confidence level malicious code snippets. Make sure the output still follows the format and structure. The output malicious code should be strictly between the tags "<start-malicious-code>" and "<end-malicious-code>". Write each code snippet on its own line. Do not include explanations, comments, or other text within the tags."""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # 5. details
    user_followup_content = (
        """Please explain why the identified code is malicious. What functionality does this code perform?"""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response


    # 6. more insights
    user_followup_content = (
        """Any other insights?"""
    )
    messages.append({"role": "user", "content": user_followup_content})
    messages.append({"role": "assistant", "content": None}) # Placeholder, to be filled in with response

    # You can add more turns here if needed in the same way as above
    # E.g., add another user prompt, then another placeholder

    return messages

def load_domain_knowledge(doc_file):
    """Load the Domain Knowledge from DomainKnowledge.docx."""
    document = Document(doc_file)
    full_text = []
    for para in document.paragraphs:
        full_text.append(para.text)
    return "\n".join(full_text)

def load_top_features(folder):
    """Load the TopFeatures from the corresponding txt file in each folder."""
    top_features_path = os.path.join(folder, "SHAP-top30-4grams-features")
    with open(top_features_path, "r", encoding="utf-8") as file:
        return file.read()


def main():
    parser = argparse.ArgumentParser(description="Generate LLM prompts from PowerShell scripts.")
    parser.add_argument("input_folder", help="Path to the folder containing PowerShell scripts.")
    parser.add_argument("output_file", help="Output JSONL file for the prompts.")
    args = parser.parse_args()

    # Load Domain Knowledge from DomainKnowledge.docx in input_folder
    doc_file = os.path.join(args.input_folder, "DomainKnowledge.docx")
    domain_knowledge = load_domain_knowledge(doc_file)

    # Process each subfolder in input_folder
    script_folders = [f for f in glob.glob(os.path.join(args.input_folder, "*")) if os.path.isdir(f)]
    #ps_files = glob.glob(os.path.join(args.input_folder, "*.ps1"))

    with open(args.output_file, "w", encoding="utf-8") as outfile:
        #for filepath in ps_files:
        for folder in script_folders:
            # Find the PowerShell script in the folder
            ps_files = glob.glob(os.path.join(folder, "*.ps1"))
            if not ps_files:
                print(f"No PowerShell script found in {folder}")
                continue
            
            ps_file = ps_files[0]
            filename = os.path.basename(ps_file)

            # Load code from the PowerShell script
            with open(ps_file, "r", encoding="utf-8") as infile:
                code = infile.read()

            # Load TopFeatures from TopFeatures.txt in the same folder
            top_features = load_top_features(folder)

            messages = generate_conversation(code, filename, domain_knowledge, top_features)

            prompt_data = {
                "custom_id": filename,
                "messages": messages
            }

            json.dump(prompt_data, outfile)
            outfile.write("\n")

    print(f"Prompts have been written to {args.output_file}")

if __name__ == "__main__":
    main()

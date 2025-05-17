# LLMs-XAI - Large Language Model Assisted PowerShell Malware Detection and Explanation

This repository provides the **dataset used in the paper** (including PowerShell scripts, SHAP results, and domain knowledge) as well as **automation scripts** for:
- Generating prompts from PowerShell scripts
- Running inference with large language models (LLMs)
- Masking malicious code based on model responses
- Analysis file using VirusTotal

## 1. Generate the Prompts

### 1.1 Code-Only
```
python3 generate_prompts-codeonly-confidence-levels.py <input_powershell_scripts_path> <output_prompts_file_name>.jsonl
```

**example**:
```
python3 generate_prompts-codeonly-confidence-levels.py powershell_scripts/codeonly prompts-codeonly.jsonl
```

### 1.2 code+domain knowledge+SHAP
```
python3 generate_prompts-code-domain-SHAP-confidence.py input_powershell_scripts_path output_prompts_file_name.jsonl
```

**example**:
```
python3 generate_prompts-code-domain-SHAP-confidence.py powershell_scripts/shap-code-domain prompts-shap-code-domain.jsonl
```

## 2. Run Inference to Get the Results
```
python3 inference.py input_prompts_file_name.jsonl output_responses_file_name.jsonl
```
**Note**: You need to specify which LLM to use by modifying the script or adding an input parameter.

**example**:
```
python3 inference.py prompts-codeonly.jsonl responses-codeonly.jsonl
```

## 3. Mask Malicious Code

### 3.1 Code-Only
```
python3 mask-malicious-code.py \
  --jsonl_file 'input_response_file_name.jsonl' \
  --powershell_dir 'input_original_powershell_scripts' \
  --output_dir 'output_cleaned_scripts' \
  --severity_level 1/2
```
- `severity_level 1`: Mask **all** malicious code  
- `severity_level 2`: Mask **high-confidence** malicious code

**example**:
```
python3 mask-malicious-code.py --jsonl_file 'responses-codeonly.jsonl' \
  --powershell_dir 'powershell_scripts/codeonly' \
  --output_dir 'cleaned_scripts_confidence_levels_all' \
  --severity_level 1 > log-responses-codeonly-confidence-levels-all.txt
```
```
python3 mask-malicious-code.py --jsonl_file 'responses-codeonly.jsonl' \
  --powershell_dir 'powershell_scripts/codeonly' \
  --output_dir 'cleaned_scripts_confidence_levels_high' \
  --severity_level 2 > log-responses-codeonly-confidence-levels-high.txt
```

### 3.2 code+domain knowledge+SHAP

**The main difference from codeonly is the parameter severity_level**
```
python3 mask-malicious-code.py \
  --jsonl_file 'input_response_file_name.jsonl' \
  --powershell_dir 'input_original_powershell_scripts' \
  --output_dir 'output_cleaned_scripts' \
  --severity_level 2/3
```
- `severity_level 2`: Mask **all** malicious code  
- `severity_level 3`: Mask **high-confidence** malicious code

**example**:
```
python3 mask-malicious-code.py --jsonl_file "responses-code-SHAP.jsonl" \
  --powershell_dir "powershell_scripts/codeonly" \
  --output_dir "cleaned_scripts_DomainK_SHAP_confidence-all" \
  --severity_level 2 > log-responses-code-domain-shap-confidence-all
```
```
python3 mask-malicious-code.py --jsonl_file "responses-code-SHAP.jsonl" \
  --powershell_dir "powershell_scripts/codeonly" \
  --output_dir "cleaned_scripts_DomainK_SHAP_confidence-high" \
  --severity_level 3 > log-responses-code-domain-shap-confidence-high
```

## 4. VirusTotal Community Score

Obtain file community scores from [VirusTotal](https://www.virustotal.com/):
```
python3 VirusTotal_checker.py your_input_folder
```
**Requires a [VirusTotal](https://www.virustotal.com/) account and API key.**
The script will generate `<your_input_folder>_log.txt` with community scores for each file.

**example**:
```
python3 VirusTotal_checker.py cleaned_scripts_confidence_levels_all
```

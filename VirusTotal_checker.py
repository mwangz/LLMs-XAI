import os
import hashlib
import requests
import time
import argparse
from openpyxl import Workbook

# Define API keys
API_KEYS = {
    "1": "***",
    "2": "***"
}

def get_file_hash(file_path):
    hasher = hashlib.sha256()
    with open(file_path, 'rb') as f:
        buf = f.read()
        hasher.update(buf)
    return hasher.hexdigest()

def upload_file_to_vt(file_path, api_key):
    with open(file_path, 'rb') as f:
        files = {'file': (os.path.basename(file_path), f)}
        params = {'apikey': api_key}
        response = requests.post('https://www.virustotal.com/vtapi/v2/file/scan', files=files, params=params)
    return response.json()

def get_vt_report(file_hash, api_key):
    params = {'apikey': api_key, 'resource': file_hash}
    response = requests.get('https://www.virustotal.com/vtapi/v2/file/report', params=params)
    return response.json()

def main(input_folder, api_key_choice):
    api_key = API_KEYS.get(api_key_choice)
    if not api_key:
        print("Invalid API key choice. Please select 1 or 2.")
        return
    
    log_filename = f"{input_folder}_log.txt"
    with open(log_filename, 'w', encoding='utf-8') as log_file:
        
        workbook = Workbook()
        sheet = workbook.active
        sheet.title = "VirusTotal Reports"
        sheet.append(["File Name", "Detections", "Report"])
        
        for filename in os.listdir(input_folder):
            file_path = os.path.join(input_folder, filename)
            if os.path.isfile(file_path):
                file_hash = get_file_hash(file_path)
                time.sleep(15)
                report = get_vt_report(file_hash, api_key)
                
                if report.get('response_code') == 0:
                    log_file.write(f"Uploading {filename} to VirusTotal...\n")
                    print(f"Uploading {filename} to VirusTotal...")
                    upload_response = upload_file_to_vt(file_path, api_key)
                    log_file.write(f"Upload response: {upload_response}\n")
                    print(f"Upload response: {upload_response}")
                    
                    print(f"Waiting for scan to complete...")
                    log_file.write("Waiting for scan to complete...\n")
                    time.sleep(30)
                    time.sleep(15)
                    report = get_vt_report(file_hash, api_key)
                
                if report.get('response_code') == 1:
                    detections = report.get('positives', 0)
                    total = report.get('total', 0)
                    detection_ratio = f"{detections}/{total}"
                    log_file.write(f"File: {filename}, Detections/Total: {detection_ratio}\n")
                    print(f"File: {filename}, Detections/Total: {detection_ratio}")
                else:
                    log_file.write(f"File: {filename}, No report available even after upload.\n")
                    print(f"File: {filename}, No report available even after upload.")

def parse_args():
    parser = argparse.ArgumentParser(description="Scan files in a folder using VirusTotal API.")
    parser.add_argument("input_folder", type=str, help="Path to the folder containing scripts")
    parser.add_argument("api_key_choice", type=str, choices=["1", "2"], help="Select API key: 1 or 2")
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    main(args.input_folder, args.api_key_choice)


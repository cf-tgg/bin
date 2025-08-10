#!/usr/bin/env python3

import json
import urllib.request
import sys

def toggle_wikipedia_language(url):
    """Switch between English and French versions of a Wikipedia page."""
    if "wikipedia.org" not in url:
        return  # Exit if not a Wikipedia page

    # Determine current language
    if url.startswith("https://en."):
        current_lang = "en"
        target_lang = "fr"
    elif url.startswith("https://fr."):
        current_lang = "fr"
        target_lang = "en"
    else:
        return  # Unsupported language

    # Extract the page title from the URL
    page_title = url.split("/wiki/")[-1]

    # Fetch the equivalent page in the target language using Wikipedia's API
    api_url = (
        f"https://{current_lang}.wikipedia.org/w/api.php"
        f"?action=query&prop=langlinks&titles={page_title}"
        f"&lllang={target_lang}&format=json"
    )

    try:
        with urllib.request.urlopen(api_url) as response:
            data = json.load(response)
        page = next(iter(data["query"]["pages"].values()))

        # Check if the target language page exists
        if "langlinks" in page:
            target_title = page["langlinks"][0]["*"]
            target_url = f"https://{target_lang}.wikipedia.org/wiki/{target_title}"
            print(target_url)  # Output only the URL
        else:
            print("No translation available.", file=sys.stderr)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)

if __name__ == "__main__":
    # The URL is passed as the first argument by Qutebrowser
    if len(sys.argv) < 2:
        print("Error: No URL provided", file=sys.stderr)
    else:
        toggle_wikipedia_language(sys.argv[1])

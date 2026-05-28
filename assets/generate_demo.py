import textwrap

def escape(s):
    return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;").replace('"', "&quot;")

frames = [
    # Scene 1: Install
    (0, "$ bash <(curl -fsSL https://raw.github.../hades-hermes-agent/main/install.sh)"),
    (1, "┌──────────────────────────────────────────────┐"),
    (1, "│ HADES - Hermes Agent Docker Installer        │"),
    (1, "└──────────────────────────────────────────────┘"),
    (2, "Select AI Provider:"),
    (2, "  1) openrouter    4) google"),
    (2, "  2) anthropic     5) deepseek"),
    (2, "  3) openai        6) custom"),
    (3, "> 1"),
    (4, "Enter OPENROUTER_API_KEY:"),
    (5, "> sk-or-v1-**********************************"),
    (6, "Enter API port [8642]:"),
    (7, "> 8642"),
    (8, "[+] Checking dependencies..."),
    (9, "    Docker is running."),
    (10,"[+] Generating configurations..."),
    (11,"    Created ~/.hades/.env"),
    (12,"    Created ~/.hades/docker-compose.yml"),
    (13,"[+] Building Docker image... (this may take a minute)"),
    (16,"    => => naming to docker.io/library/hades"),
    (17,"[+] Starting HADES container..."),
    (18,"    Container hades-gateway-1  Started"),
    (19,"[+] HADES is ready! API server listening on 127.0.0.1:8642"),
    
    # Scene 2: Usage
    (21, "\n$ hades cli"),
    (22, "Connected to Hermes Agent."),
    (23, "Type '/help' for commands, or just chat."),
    (24, "> /status"),
    (25, "Agent State: IDLE"),
    (25, "Provider: openrouter | Model: deepseek/deepseek-v4-flash:free"),
    
    # Scene 3: Commands
    (27, "\n$ hades update"),
    (28, "Pulling latest changes..."),
    (29, "Rebuilding image..."),
    (30, "Restarting container..."),
    (31, "\n$ hades url"),
    (32, "http://127.0.0.1:8642"),
]

# Total animation time: ~35 units * 200ms = 7 seconds
delay = 0.2
duration_s = max(f[0] for f in frames) * delay + 2.0

svg = f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 800 450" width="800" height="450">
  <style>
    .bg {{ fill: #0d1117; }}
    .text {{ font-family: 'Cascadia Code', 'Fira Code', 'Courier New', monospace; font-size: 14px; fill: #c9d1d9; }}
    .cmd {{ fill: #58a6ff; font-weight: bold; }}
    .prompt {{ fill: #3fb950; font-weight: bold; }}
    .highlight {{ fill: #f0883e; }}
  </style>
  <rect width="800" height="450" rx="8" class="bg"/>
  
  <!-- Mac window controls -->
  <circle cx="20" cy="20" r="6" fill="#ff5f56"/>
  <circle cx="40" cy="20" r="6" fill="#ffbd2e"/>
  <circle cx="60" cy="20" r="6" fill="#27c93f"/>
'''

max_time = max(f[0] for f in frames)

# Generate visibility keyframes for each line
lines_by_time = []
for t, text in frames:
    lines_by_time.append((t, text))

current_y = 50
for t, text in lines_by_time:
    is_cmd = text.startswith("$")
    is_prompt = text.startswith(">")
    
    cls = "text"
    if is_cmd:
        text = f'<tspan class="prompt">$</tspan> <tspan class="cmd">{escape(text[2:])}</tspan>'
    elif is_prompt:
        text = f'<tspan class="prompt">&gt;</tspan> <tspan class="highlight">{escape(text[2:])}</tspan>'
    else:
        text = escape(text)
        
    start_pct = (t * delay) / duration_s * 100
    
    svg += f'''
  <g opacity="0">
    <text x="20" y="{current_y}" class="{cls}">{text}</text>
    <animate attributeName="opacity" values="0;0;1;1" keyTimes="0; {max(0, start_pct-0.1)/100:.3f}; {start_pct/100:.3f}; 1" dur="{duration_s}s" repeatCount="indefinite" />
  </g>'''
    
    if text.strip():
        current_y += 20

svg += '\n</svg>'

with open('/home/idx-332/hdi/assets/demo.svg', 'w') as f:
    f.write(svg)

print("Created demo.svg")

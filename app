import os
import requests
from flask import Flask, request
from datetime import datetime

TOKEN = os.getenv("TELEGRAM_TOKEN", "8571915925:AAGAlDNFeKCZrJZO98ahEwAHvUZLOUT944M")
BASE_URL = f"https://api.telegram.org/bot{TOKEN}"
PORT = int(os.getenv("PORT", 8080))

app = Flask(__name__)
users = {}

def send(cid, txt):
    requests.post(f"{BASE_URL}/sendMessage", json={"chat_id": cid, "text": txt, "parse_mode": "Markdown"}, timeout=5)

def reply(txt, uid):
    if uid not in users: users[uid] = {"balance": 0.0}
    txt = txt.lower().strip()

    if txt == "/start":
        return "*Bot SMS 24/7!*\n\n/saldo - Ver saldo\n/precos - Preços\n/depositar - PIX\n/comprar - Comprar\n\nRússia R$ 0,60\nEUA R$ 1,00\nBrasil R$ 2,50"
    elif txt == "/saldo":
        return f"*Saldo:* R$ {users[uid]['balance']:.2f}\n\n/depositar /comprar"
    elif txt == "/precos":
        return "*Preços:*\n\nRússia R$ 0,60\nEUA R$ 1,00\nBrasil R$ 2,50"
    elif txt == "/depositar":
        return "*PIX*\n\nDigite valor (min R$ 1)\nEx: 5.00"
    elif txt == "/comprar":
        return f"*Comprar*\n\nSaldo: R$ {users[uid]['balance']:.2f}\n\n/comprar_russia R$ 0,60\n/comprar_usa R$ 1,00\n/comprar_brazil R$ 2,50"
    elif "comprar_" in txt:
        return "Tenha saldo primeiro!\n/depositar"
    else:
        return f"`{txt}`\n\nUse /start"

@app.route('/webhook', methods=['POST'])
def webhook():
    try:
        u = request.get_json()
        if 'message' in u:
            m = u['message']
            cid, uid, txt = m['chat']['id'], m['from']['id'], m.get('text', '')
            print(f"{datetime.now().strftime('%H:%M:%S')} | {txt}")
            send(cid, reply(txt, uid))
        return 'OK', 200
    except: return 'Error', 500

@app.route('/health')
def health():
    return {"status": "ok", "bot": "@smstemporarybot", "users": len(users)}

@app.route('/')
def home():
    return "<h1>Bot Online</h1><p>@smstemporarybot</p><a href='/health'>Health</a>"

def setup_webhook():
    domain = os.getenv("RAILWAY_PUBLIC_DOMAIN")
    if domain:
        url = f"https://{domain}/webhook"
        r = requests.post(f"{BASE_URL}/setWebhook", json={"url": url})
        print(f"Webhook: {url} - {r.json()}")

if __name__ == '__main__':
    print("Bot iniciado!")
    setup_webhook()
    app.run(host='0.0.0.0', port=PORT)

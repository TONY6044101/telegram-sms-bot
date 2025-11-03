web: gunicorn app:app --bind 0.0.0.0:$PORT --workers 2 --timeout 120

## ARQUIVO 4: railway.json
{
  "build": {"builder": "NIXPACKS"},
  "deploy": {
    "startCommand": "gunicorn app:app --bind 0.0.0.0:$PORT --workers 2",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}

## VARIÁVEIS DE AMBIENTE (Railway):
TELEGRAM_TOKEN=8571915925:AAGAlDNFeKCZrJZO98ahEwAHvUZLOUT944M
PLUGGY_CLIENT_ID=3d15ed55-b74a-4b7c-8bcc-430e80cf01ab
PLUGGY_CLIENT_SECRET=ccef002e-7935-452b-ace8-dde1db125e81
SMS_ACTIVATE_KEY=c4e874f298810bd18b9AAb468e1d021f
PORT=8080

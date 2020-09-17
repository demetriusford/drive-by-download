import base64


def b64(path):
    try:
        with open(path, 'rb') as payload:
            encoded = base64.b64encode(payload.read())
        return encoded.decode('utf-8')
    except FileNotFoundError:
        raise

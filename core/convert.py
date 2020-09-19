from pathlib import Path


def sub(args):
    root = Path(__file__).resolve().parents[1]
    try:
        payload = root.joinpath('js', 'payload.js')

        with open(payload, 'r') as javascript:
            code = javascript.readlines()

        return ''.join(
            [line.replace('{{ 0 }}', args[0])
                 .replace('{{ 1 }}', args[1]) for line in code])
    except FileNotFoundError:
        raise

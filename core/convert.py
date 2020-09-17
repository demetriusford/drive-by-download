from pathlib import Path


def sub(a, b):
    root = Path(__file__).resolve().parents[1]
    try:
        with open(root.joinpath('js', 'payload.js'), 'r') as f:
            javascript = f.readlines()
        return ''.join(
            [js.replace('{{ 0 }}', a)
               .replace('{{ 1 }}', b) for js in javascript])
    except FileNotFoundError:
        raise

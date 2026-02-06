# dbd (Drive-by-Download)

Generate a post exploit script to download an arbitrary file using HTML5's Blob object (https://developer.mozilla.org/en-US/docs/Web/API/Blob).

## Quick Start

```bash
$ bundle install
$ ./bin/dbd -f payload.exe
```

## How It Works

1. Your file is Base64-encoded and embedded in a JS payload
2. When executed in a browser, the JS decodes the data into a Blob
3. A hidden anchor element triggers an automatic download
4. The victim sees a file download with a randomized filename

## Usage

```bash
# Basic usage (extension inferred from file)
$ ./bin/dbd -f document.pdf

# Override the download extension
$ ./bin/dbd -f stage1.bin -e .doc

# Save to file
$ ./bin/dbd -f payload.exe > inject.js

# Copy to clipboard (macOS)
$ ./bin/dbd -f payload.exe | pbcopy
```

## Options

| Option        | Alias | Description                                    |
|---------------|-------|------------------------------------------------|
| `--evil-file` | `-f`  | Path to the file to embed (required)           |
| `--extension` | `-e`  | Override download extension (.doc, .pdf, .exe) |
| `--version`   | `-v`  | Print version                                  |

## Evasion Techniques

The generated payload includes basic obfuscation:

- String concatenation splits suspicious function names (`'at'+'ob'`, `'Bl'+'ob'`)
- No easily-greppable signatures exist such as `atob`, `Blob`, `createElement`
- Single-letter variable names
- Minified single-line output

### Increasing Evasion

For stronger evasion, consider these high-impact techniques:

**1. JS Obfuscators**

Defeats static analysis. Tools like `javascript-obfuscator` mangle control flow, encode strings, and add dead code:

```bash
$ ./bin/dbd -f payload.exe | javascript-obfuscator --compact true --string-array true
```

**2. Encrypted Payload**

Defeats dynamic analysis by ensuring the payload cannot be decrypted without authentic user interaction.

**Encryption (generation time):** Before embedding the Base64 data in the template, encrypt it using `AES-GCM. Generate a random initialization vector and encrypt the payload with a symmetric key. Embed the IV alongside the ciphertext in the template.

**Decryption (runtime):** Use the Web Crypto API's `subtle.decrypt` method to reverse the encryption. This is built into all modern browsers with no external dependencies. The payload waits for user interaction before attempting decryption.

**Key derivation (the critical layer):** Rather than embedding a static key, derive it from user interaction at runtime. Options include mouse click coordinates, the timing intervals between keystrokes, mouse movement velocity, or scroll position. Hash these values to produce a consistent 256-bit key for AES.

**Why sandboxes fail:** Automated analysis environments execute JavaScript but cannot produce authentic user behavior. Simulated clicks occur at coordinates like (0,0) or lack realistic timing. Without valid interaction data, the derived key is incorrect, AES decryption fails, and the payload remains inert. Analysts see only encrypted data, while real users trigger decryption through normal interaction.

**3. Polymorphic Generation**

Defeats signature-based detection by producing a unique payload on every generation.

**How it works:** Instead of using fixed variable names like `a`, `b`, `w`, `d`, the generator randomizes identifiers on each run. Variable names, function names, string split points, and code structure all vary. Two payloads embedding the same file will look completely different at the source level while functioning identically.

**What to randomize:** Variable and function names can be random strings or drawn from a pool of innocent-looking names (e.g., `config`, `data`, `init`, `handler`). The points where strings are split for concatenation can vary (`'at'+'ob'` vs `'a'+'tob'` vs `'ato'+'b'`). Dead code and no-op statements can be inserted at random positions. The order of independent operations can be shuffled.

**Why signatures fail:** Security tools that rely on pattern matching look for known byte sequences or AST structures. When every payload is structurally unique, no single signature matches. Analysts must reverse-engineer each sample individually rather than relying on automated classification.

**Implementation:** Modify the ERB template to use Ruby's `SecureRandom` for generating identifiers at render time. Alternatively, post-process the output with a polymorphic engine that rewrites the AST while preserving semantics.

## Browser Support

Works in all modern browsers:
- Chrome, Edge, Firefox, Safari, Opera
- Requires JavaScript enabled
- Requires `Blob` and `URL.createObjectURL` support (IE10+)

## Limitations

- Large file sizes will generate Base64 overhead
- CSP `script-src` restrictions may block inline/external scripts
- AV/EDR evasion is not currently handled  
- MIME sniffing via the browser may issue warnings on `.doc` files with PE headers

## Library Usage

Integrate into your own Ruby tools:

```ruby
require "dbd"

payload = Dbd::PayloadService.new(
  extension: ".exe",
  file_path: "/path/to/stage1.bin"
).call

puts payload
```

## Legal

This tool is intended for authorized security testing only. Obtain proper authorization before use. Misuse of this tool may violate local laws.

## License

Apache License 2.0. See [LICENSE](LICENSE).

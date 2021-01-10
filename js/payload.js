class MimeFactory {
  constructor(type) {
    const mimes = {
      '.doc': 'application/msword'
      , '.pdf': 'application/pdf'
      , '.exe': 'application/octet-stream'
    , }

    if (!(type in mimes)) {
      return;
    }

    this.type = mimes[type];
  }
}

((file, payload) => {
  const empty = ({
    length
  }) => length === 0;

  if (empty(file) || empty(payload)) return;

  const decoded = window.atob(payload);

  const mime = new MimeFactory(file);
  const size = payload.length;
  const link = document.createElement('a');

  const bin = new Uint8Array(size);
  for (let i = 0; i < size; i++) {
    bin[i] = decoded.charCodeAt(i);
  }

  const blob = new Blob([bin.buffer]
    , {
      type: mime.type
    });

  const url = window.URL.createObjectURL(blob);

  link.style = 'display:none;';
  link.href = url;
  link.download = file;

  document.body.appendChild(link);
  link.click();

  window.URL.revokeObjectURL(url);
  document.body.removeChild(link);

})('{{ 0 }}', '{{ 1 }}');

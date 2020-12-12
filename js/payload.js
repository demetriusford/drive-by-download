((file, payload) => {
  const empty = ({
    length
  }) => length === 0;

  if (empty(file) || empty(payload)) return;

  const decoded = window.atob(payload);
  const size = payload.length;
  const a = document.createElement('a');

  const bin = new Uint8Array(size);i
  for (let i = 0; i < size; i++) {
    bin[i] = decoded.charCodeAt(i);
  }

  const blob = new Blob([bin.buffer]
    , {
      type: 'octet/stream'
    });

  const url = window.URL.createObjectURL(blob);

  a.style = 'display:none;';
  a.href = url;
  a.download = file;

  document.body.appendChild(a);
  a.click();

  window.URL.revokeObjectURL(url);
  document.body.removeChild(a);

})('{{ 0 }}', '{{ 1 }}');

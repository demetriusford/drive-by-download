((file, payload) => {
  const empty = ({
    length
  }) => length === 0;

  if (!file.length || !payload.length) {
    return false;
  }

  const a = document.createElement('a');
  const macroDocument = window.atob(payload);
  const sizeOfPayload = payload.length;

  let bytes = new Uint8Array(sizeOfPayload);
  for (let i = 0; i < sizeOfPayload; i++) {
    bytes[i] = macroDocument.charCodeAt(i);
  }

  const blob = new Blob([bytes.buffer]
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

  return true;
})('{{ 0 }}', '{{ 1 }}');

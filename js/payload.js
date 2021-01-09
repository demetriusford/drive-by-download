class MimeFactory {
  constructor(type) {
    if (type === '.doc') {
      return 'application/msword';
    } else if (type === '.pdf') {
      return 'application/pdf';
    } else {
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    }
  }
}

((file, payload) => {
  const empty = ({
    length
  }) => length === 0;

  if (empty(file) || empty(payload)) return;

  const decoded = window.atob(payload);

  const type = new MimeFactory(file);
  const size = payload.length;
  const link = document.createElement('a');

  const bin = new Uint8Array(size);
  for (let i = 0; i < size; i++) {
    bin[i] = decoded.charCodeAt(i);
  }

  const blob = new Blob([bin.buffer]
    , {
      type: type
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

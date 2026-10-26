// Builds the mailto link at runtime so the address never appears in the HTML source.
// Markup: <span data-email-u="<reversed user>" data-email-d="<reversed domain>">fallback text</span>
(function () {
  function reverse(s) { return s.split('').reverse().join(''); }

  document.querySelectorAll('[data-email-u]').forEach(function (el) {
    var address = reverse(el.getAttribute('data-email-u')) + '@' + reverse(el.getAttribute('data-email-d'));
    var link = document.createElement('a');
    link.href = 'mailto:' + address;
    link.textContent = address;
    el.replaceChildren(link);
  });
})();

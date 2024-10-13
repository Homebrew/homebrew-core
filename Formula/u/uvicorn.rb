class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/76/87/a886eda9ed495a3a4506d5a125cd07c54524280718c4969bde88f075fe98/uvicorn-0.31.1.tar.gz"
  sha256 "f5167919867b161b7bcaf32646c6a94cdbd4c3aa2eb5c17d36bb9aa5cfd8c493"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "087d97f9768bcd44f80d0d0ef3fcafc56a99335b25d97f2b3a17233b426b3a04"
    sha256 cellar: :any,                 arm64_sonoma:  "5b852e1c6fa7079b9b9b11c5a805a2906e08934838615ebc545797d2143250f9"
    sha256 cellar: :any,                 arm64_ventura: "ab9dba37ca13b39a8373d7bef1aa9f3f5cc790d65a4a4c0e285c17b029782bda"
    sha256 cellar: :any,                 sonoma:        "49fe70e58948a90a93b05a3f7b4677f7ee058305eeb42f54200da8d9594b5fa3"
    sha256 cellar: :any,                 ventura:       "d063f20f35490c92377ef5171f03e53ef77c51ecfed84f43f62820b1f273d956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4873a129d072481793cac940198a78e0f1aba8078035e280d072ca7adf0671a"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/78/49/f3f17ec11c4a91fe79275c426658e509b07547f874b14c1a526d86a83fc8/anyio-4.6.0.tar.gz"
    sha256 "137b4559cbb034c477165047febb6ff83f390fc3b20bf181c1fc0a728cb8beeb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/67/1d/d77686502fced061b3ead1c35a2d70f6b281b5f723c4eff7a2277c04e4a2/httptools-0.6.1.tar.gz"
    sha256 "c6e26c30455600b95d94b1b836085138e82f177351454ee841c148f93a9bad5a"

    # relax cython version constraint, upstream pr ref, https://github.com/MagicStack/httptools/pull/101
    patch :DATA
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/cf/3d/a150e044b5bc69961168b024c531d21b63acd9948b7d681b03e551be01e1/uvloop-0.21.0b1.tar.gz"
    sha256 "5e12901bd67c5ba374741fc497adc44de14854895c416cd0672b2e5b676ca23c"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c8/27/2ba23c8cc85796e2d41976439b08d52f691655fdb9401362099502d1f0cf/watchfiles-0.24.0.tar.gz"
    sha256 "afb72325b74fa7a428c009c1b8be4b4d7c2afedafb2982827ef2156646df2fe1"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/e2/73/9223dbc7be3dcaf2a7bbf756c351ec8da04b1fa573edaf545b95f6b0c7fd/websockets-13.1.tar.gz"
    sha256 "a3b3366087c1bc0a2795111edcadddb8b3b59509d5db5d7ea3fdd69f954a8878"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"uvicorn", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath/"example.py").write <<~EOS
      async def app(scope, receive, send):
          assert scope['type'] == 'http'

          await send({
              'type': 'http.response.start',
              'status': 200,
              'headers': [
                  (b'content-type', b'text/plain'),
              ],
          })
          await send({
              'type': 'http.response.body',
              'body': b'Hello, Homebrew!',
          })
    EOS

    port = free_port
    pid = fork do
      exec bin/"uvicorn", "--port=#{port}", "example:app"
    end

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

__END__
diff --git a/httptools/parser/parser.c b/httptools/parser/parser.c
index 1b64e55..4a59122 100644
--- a/httptools/parser/parser.c
+++ b/httptools/parser/parser.c
@@ -9937,7 +9937,7 @@ static CYTHON_INLINE long __Pyx_PyInt_As_long(PyObject *x) {
                 unsigned char *bytes = (unsigned char *)&val;
                 int ret = _PyLong_AsByteArray((PyLongObject *)v,
                                               bytes, sizeof(val),
-                                              is_little, !is_unsigned);
+                                              is_little, !is_unsigned, 0);
                 Py_DECREF(v);
                 if (likely(!ret))
                     return val;
@@ -10133,7 +10133,7 @@ static CYTHON_INLINE int __Pyx_PyInt_As_int(PyObject *x) {
                 unsigned char *bytes = (unsigned char *)&val;
                 int ret = _PyLong_AsByteArray((PyLongObject *)v,
                                               bytes, sizeof(val),
-                                              is_little, !is_unsigned);
+                                              is_little, !is_unsigned, 0);
                 Py_DECREF(v);
                 if (likely(!ret))
                     return val;
diff --git a/httptools/parser/url_parser.c b/httptools/parser/url_parser.c
index c9e646a..e9a5f01 100644
--- a/httptools/parser/url_parser.c
+++ b/httptools/parser/url_parser.c
@@ -5547,7 +5547,7 @@ static CYTHON_INLINE long __Pyx_PyInt_As_long(PyObject *x) {
                 unsigned char *bytes = (unsigned char *)&val;
                 int ret = _PyLong_AsByteArray((PyLongObject *)v,
                                               bytes, sizeof(val),
-                                              is_little, !is_unsigned);
+                                              is_little, !is_unsigned, 0);
                 Py_DECREF(v);
                 if (likely(!ret))
                     return val;
@@ -5743,7 +5743,7 @@ static CYTHON_INLINE int __Pyx_PyInt_As_int(PyObject *x) {
                 unsigned char *bytes = (unsigned char *)&val;
                 int ret = _PyLong_AsByteArray((PyLongObject *)v,
                                               bytes, sizeof(val),
-                                              is_little, !is_unsigned);
+                                              is_little, !is_unsigned, 0);
                 Py_DECREF(v);
                 if (likely(!ret))
                     return val;
diff --git a/setup.py b/setup.py
index 200e6f6..adca1f8 100644
--- a/setup.py
+++ b/setup.py
@@ -15,7 +15,7 @@ CFLAGS = ['-O2']

 ROOT = pathlib.Path(__file__).parent

-CYTHON_DEPENDENCY = 'Cython(>=0.29.24,<0.30.0)'
+CYTHON_DEPENDENCY = 'Cython>=0.29.24'


 class httptools_build_ext(build_ext):

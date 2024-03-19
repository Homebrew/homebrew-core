class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/62/25/7f0bfc9055284129bfd2977fb3460ac78aa4d127fd2b8391e7eb93002bef/uvicorn-0.28.1.tar.gz"
  sha256 "08103e79d546b6cf20f67c7e5e434d2cf500a6e29b28773e407250c54fc4fa3c"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c422726646b5d0b9db08805567903c5c9b63d12ce96f4c7c2a3a7f0cc1e0ebfd"
    sha256 cellar: :any,                 arm64_ventura:  "ac20675bb745e7ea61f6d6346c2f472d97cdbd19217b860b8c6bb26dd66a9fd5"
    sha256 cellar: :any,                 arm64_monterey: "42cbe969a7093aa134cb3cc7c6d20a55a7a97b682d646f91fbdf9c55e5c292c9"
    sha256 cellar: :any,                 sonoma:         "86b9fc075d82b18a876230b7c273a0b49fb282b34edf7f581825760f5d7cb110"
    sha256 cellar: :any,                 ventura:        "b4c64a0d00763b5747f49557e15962034e3024bf3e9be2275ddf0aa0e5b4c6ec"
    sha256 cellar: :any,                 monterey:       "bc324598f19e0dfa24f979521f3d9035e99d6384122b1edd41fcc8fde4cffa4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c3d9c1febdfde83345743b4830cdd3b4f2d8763d47fd7249fbd2646583a0778"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
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
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/9c/16/728cc5dde368e6eddb299c5aec4d10eaf25335a5af04e8c0abd68e2e9d32/uvloop-0.19.0.tar.gz"
    sha256 "0246f4fd1bf2bf702e06b0d45ee91677ee5c31242f39aab4ea6fe0c51aedd0fd"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/66/79/0ee412e1228aaf6f9568aa180b43cb482472de52560fbd7c283c786534af/watchfiles-0.21.0.tar.gz"
    sha256 "c76c635fabf542bb78524905718c39f736a98e5ab25b23ec6d4abede1a85a6a3"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/2e/62/7a7874b7285413c954a4cca3c11fd851f11b2fe5b4ae2d9bee4f6d9bdb10/websockets-12.0.tar.gz"
    sha256 "81df9cbcbb6c260de1e007e58c011bfebe2dafc8435107b0537f393dd38c8b1b"
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

class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://www.uvicorn.org/"
  url "https://files.pythonhosted.org/packages/09/d8/8aa69c76585035ca81851d99c3b00fd6be050aefd478a5376ff9fc5feb69/uvicorn-0.27.1.tar.gz"
  sha256 "3d9a267296243532db80c83a959a3400502165ade2c1338dea4e67915fd4745a"
  license "BSD-3-Clause"
  head "https://github.com/encode/uvicorn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3debc30b1e8d7205f6d003f33fff0414e03314d22e3e30008237889e63dbfe3c"
    sha256 cellar: :any,                 arm64_ventura:  "ab6af8554607f8e8fce39d53da52b3c89643238d9200e1e4ad80dc2eb9e93755"
    sha256 cellar: :any,                 arm64_monterey: "9018dd8d2fd773965750c1853e83e10c0162b7420edac23c1e22e036625f9215"
    sha256 cellar: :any,                 sonoma:         "1146e65fa737db10ca29d7d7a2b604b431f2482e68e536928ef08e8b99bb0fac"
    sha256 cellar: :any,                 ventura:        "8436edfa51a646a5a67d8bc09a670b6ea8cc51e43e890ad5f9e46b2ef8ef641e"
    sha256 cellar: :any,                 monterey:       "9c581e54813ba0ba16db5ce1488bf08bb0d24a7fe1d826abb7ba54902bbee981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4b011d0734942cf73989c0d810201ef170147f95628a7e5c664a57ee03447e"
  end

  depends_on "rust" => :build
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
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

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
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

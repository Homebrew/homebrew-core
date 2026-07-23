class Uvicorn < Formula
  include Language::Python::Virtualenv

  desc "ASGI web server"
  homepage "https://uvicorn.dev/"
  url "https://files.pythonhosted.org/packages/a2/65/b7c6c443ccc58678c91e1e973bbe2a878591538655d6e1d47f24ba1c51f3/uvicorn-0.51.0.tar.gz"
  sha256 "f6f4b69b657c312f516dd2d268ab9ae6f254b11e4bac504f37b2ab58b24dd0b0"
  license "BSD-3-Clause"
  head "https://github.com/Kludex/uvicorn.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6a8c447fb260bfbee2160e466775ebc5376ec0e05610e862bcf4416817ce3d9e"
    sha256 cellar: :any, arm64_sequoia: "1e8d2ca62f0183629c7d791fa492b0ad6eeb1fe0ecf94cd4dca5016f0e5994c6"
    sha256 cellar: :any, arm64_sonoma:  "a1dfaf95ae07a376bfc54ad2b0340698bf2d848311fb1e9e0316dec438cfac9a"
    sha256 cellar: :any, sonoma:        "67793ac7b2627c0bef027e432587c14160d94cc0c37f807d6868db10e1027048"
    sha256 cellar: :any, arm64_linux:   "658acee90590c6c20139b9fb3323d52df362d3e2a93381b9163460a3c342ddea"
    sha256 cellar: :any, x86_64_linux:  "1e7a4fd833aab788e2418f34979a6ac3267bd2e394a0798c17a34b55e129325e"
  end

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "uvicorn[standard]"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/3b/72/5562aabb8dd7181e8e860622a38bea08d17842b99ecd4c91f84ac95251b0/anyio-4.14.1.tar.gz"
    sha256 "8d648a3544c1a700e3ff78615cd679e4c5c3f149904287e73687b2596963629e"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httptools" do
    url "https://files.pythonhosted.org/packages/43/e5/d471fcb0e14523fe1c3f4ba58ca52480e7bd70ad7109a3846bc75892f7fb/httptools-0.8.0.tar.gz"
    sha256 "6b2a32f18d97e16e90827d7a819ffa8dbd8cc245fc4e1fa9d1095b54ef4bd999"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "uvloop" do
    url "https://files.pythonhosted.org/packages/06/f0/18d39dbd1971d6d62c4629cc7fa67f74821b0dc1f5a77af43719de7936a7/uvloop-0.22.1.tar.gz"
    sha256 "6c84bae345b9147082b17371e3dd5d42775bddce91f885499017f4607fdaf39f"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"uvicorn", shell_parameter_format: :click)
  end

  test do
    (testpath/"example.py").write <<~PYTHON
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
    PYTHON

    port = free_port
    pid = spawn bin/"uvicorn", "--port=#{port}", "example:app"

    assert_match "Hello, Homebrew!", shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}/")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

class Robotcode < Formula
  include Language::Python::Virtualenv

  desc "Ultimate Robot Framework Toolset"
  homepage "https://robotcode.io"
  url "https://files.pythonhosted.org/packages/b5/0f/d2d20377b7835eec1c53f9b51bd1ed839c34f2d326864dbb02c601bcca1f/robotcode-2.7.0.tar.gz"
  sha256 "c07031d5103affc0de98a474a584b27f7dc2589bc908e0b908ca10969e617421"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dc02d922264811178c04dbfd08b9392eac51531704dfa4239dd5f6bb606ad145"
    sha256 cellar: :any, arm64_sequoia: "72d4063f3a2822a6cd6a717e64265afc7394132c9beb58cb7d91ecd64c31a805"
    sha256 cellar: :any, arm64_sonoma:  "53c2166d27e0edcd855340e74850db31d37a10a41ec932066cf482c76d7aea73"
    sha256 cellar: :any, sonoma:        "2c2397817576f74f14584d570bc467917fd04d51c9cffceea861e6ceb3bcb687"
    sha256 cellar: :any, arm64_linux:   "ff091dc169596b248548510f29d0f161f945d09dae9576d6c90c8468d6ab7986"
    sha256 cellar: :any, x86_64_linux:  "5df9e93a9ea8ec9c5cac1ae6acbf5dca1079db2981a63c8f31de5726c561b3a3"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages package_name: "robotcode[all]"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/31/f9/c0a1c127f9049db9155afc316952ea571720dd01833ff5e4d7e8e6352dbb/msgpack-1.2.1.tar.gz"
    sha256 "04c721c2c7448767e9e3f2520a475663d8ee0f09c31890f6d2bd70fd636a9647"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b8/d7/e7bfbc86e9f99ff7807e24de7703f032e9c9ba80bb355cf26e0e9bc5a75e/platformdirs-4.11.3.tar.gz"
    sha256 "66a73d38a849810252df809a3d8bcbda8e26f6c189920e7535ad608a48dbb5ab"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/fb/48/fb042503b6ca6cd271261dc559fd6432f7d8c713153e9ec5c591af4dfc1c/pytz-2026.3.post1.tar.gz"
    sha256 "2211d3fcf9a797d3405cac96ac7f61d80e6a644f72a3309607282fe8a2010c5d"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "robotcode-analyze" do
    url "https://files.pythonhosted.org/packages/5e/d0/fcbb84216a9cd840b95c81c3537148926c1b96d78590fa2266b7472c0987/robotcode_analyze-2.7.0.tar.gz"
    sha256 "073e472152321072e43eb80cb540357a0edfc8c9af09977dc9575b0fb4bdcf31"
  end

  resource "robotcode-core" do
    url "https://files.pythonhosted.org/packages/a9/6e/0588918df4efd5340d7616e3712f6b3caffc9e2fd80da3cd12bace7d8aef/robotcode_core-2.7.0.tar.gz"
    sha256 "39d493ef4c3c4c6721e9487135c8b5d2256588a3d1b8947ff1bacaf73dc0149c"
  end

  resource "robotcode-debugger" do
    url "https://files.pythonhosted.org/packages/14/4e/09ef5b227e7ccef7c6b406dcd082700d8e95216dd93d3a9e87f21adcd940/robotcode_debugger-2.7.0.tar.gz"
    sha256 "7a6b31ad801caa3de9c37ca6ad25a7a104ac142d06099a58d2b2c25f081b9214"
  end

  resource "robotcode-jsonrpc2" do
    url "https://files.pythonhosted.org/packages/51/3f/ef17bfcd7649d365e1c89c4825241b16295583624ffdbca5f96f1bc33917/robotcode_jsonrpc2-2.7.0.tar.gz"
    sha256 "cb4301739c33989698099f51bc913b473ef1e2347c2fa5dfb5ff3e6462e9ddee"
  end

  resource "robotcode-language-server" do
    url "https://files.pythonhosted.org/packages/f2/ae/1526491abe8742d1089dba06521046b89d763a81785262dee591e71a2010/robotcode_language_server-2.7.0.tar.gz"
    sha256 "de5839055dc67973d0706aa8a4d77cda06fa2dc6e9e3a478bc853549930036cf"
  end

  resource "robotcode-modifiers" do
    url "https://files.pythonhosted.org/packages/9d/42/d655c03da401d7b7f8f2019e7acb0196f476a763d7df07110ce18ec2be40/robotcode_modifiers-2.7.0.tar.gz"
    sha256 "86414abd296be9509449210028b2c698aa7213f55b8ced740de0b2fcb6fa4e15"
  end

  resource "robotcode-plugin" do
    url "https://files.pythonhosted.org/packages/fd/cf/7267f03a8c46e8cd2b2a33cf3957c1fa4917e0ca23ac47b7e8e2f49fc71d/robotcode_plugin-2.7.0.tar.gz"
    sha256 "1e0f5c40f09c8868ae768f23f4d9bb838ecd1db6a50bf470304acec4cf185800"
  end

  resource "robotcode-repl" do
    url "https://files.pythonhosted.org/packages/0b/b5/20b65d673d31e42c1c44f0b3e298707402f2f2602ec8e381b87ece1f190d/robotcode_repl-2.7.0.tar.gz"
    sha256 "a5ebabf3fe8a12a140a7b45a9d2fe270b01ed25d27a6ff0eb2c99e2f991beb6f"
  end

  resource "robotcode-repl-server" do
    url "https://files.pythonhosted.org/packages/7b/9d/dd2df90adfc4080957bc0587f1e41ac1760c316f17270126e708dd95b04b/robotcode_repl_server-2.7.0.tar.gz"
    sha256 "a203a13b64f52f8f3fd4774e85ed41d6171f42ed8e7f2154845d5db919050918"
  end

  resource "robotcode-robot" do
    url "https://files.pythonhosted.org/packages/75/ec/e40cf80eaf630c6b321252bf85783d08d72a86e0e8c44ab1356eda873eca/robotcode_robot-2.7.0.tar.gz"
    sha256 "f2976b2ef5f38ac26c7769b8f65a063b197f7642f4cc5e449e72b03858943744"
  end

  resource "robotcode-runner" do
    url "https://files.pythonhosted.org/packages/a5/8a/3d0d41c63be6445a103ca73afaa0e7de2cbfb3551f2382b2a3216098486b/robotcode_runner-2.7.0.tar.gz"
    sha256 "3c2899f91857eb6b14ee50b71d92dfe0878075103ea99516188fb1b88d510035"
  end

  resource "robotframework" do
    url "https://files.pythonhosted.org/packages/19/f3/ad51daf85d95848831601851598640f951a47a9f9de88039235cf58c5bb9/robotframework-7.4.2.tar.gz"
    sha256 "1c934e7f43600de407860cd2bd2fdc41adad4a4a785d8b46b1ed485fdc0f6c9f"
  end

  resource "robotframework-robocop" do
    url "https://files.pythonhosted.org/packages/83/17/34141292d0d9d552d2d2bc7107a9c66111d10b932cd594fcaa3dfaf44a72/robotframework_robocop-8.8.0.tar.gz"
    sha256 "8da173558587e0d0b3f51ac0bd9d333414a7c28565563d4a93d829f10652dedb"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/ae/40/4a3db7990d1f62a53182aa96eaef57aeb2886a27f90a195bc66713565d31/typer-0.27.1.tar.gz"
    sha256 "a79bef8469a79c45498e7b814ecf8d603cc7644e9acbd9e19cac0334240b18df"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "open3"

    (testpath/"test.robot").write <<~ROBOT
      *** Test Cases ***
      Homebrew
          Should Be Equal    Homebrew    Homebrew
    ROBOT

    assert_match "1 test, 1 passed, 0 failed", shell_output("#{bin}/robotcode robot test.robot")

    initialize_request, shutdown_request, exit_notification = [
      {
        jsonrpc: "2.0", id: 1, method: "initialize",
        params: { rootUri: nil, capabilities: {} }
      },
      { jsonrpc: "2.0", id: 2, method: "shutdown" },
      { jsonrpc: "2.0", method: "exit" },
    ].map { |request| JSON.generate(request) }

    Open3.popen3(bin/"robotcode", "language-server", "--stdio") do |stdin, stdout, stderr, wait_thr|
      send_message = lambda do |request|
        stdin.write "Content-Length: #{request.bytesize}\r\n\r\n#{request}"
        stdin.flush
      end
      read_response = lambda do
        length = stdout.readline[/\d+/].to_i
        stdout.each_line.take_while { |line| line != "\r\n" }
        JSON.parse(stdout.read(length))
      end

      send_message.call(initialize_request)
      assert_kind_of Hash, read_response.call.dig("result", "capabilities")

      send_message.call(shutdown_request)
      read_response.call
      send_message.call(exit_notification)
      stdin.close
      assert wait_thr.value.success?, stderr.read
    end
  end
end

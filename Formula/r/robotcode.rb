class Robotcode < Formula
  include Language::Python::Virtualenv

  desc "Ultimate Robot Framework Toolset"
  homepage "https://robotcode.io"
  url "https://files.pythonhosted.org/packages/b5/0f/d2d20377b7835eec1c53f9b51bd1ed839c34f2d326864dbb02c601bcca1f/robotcode-2.7.0.tar.gz"
  sha256 "c07031d5103affc0de98a474a584b27f7dc2589bc908e0b908ca10969e617421"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "3982cffd2bad7ace4dad33e7b136d7ecdf5939f565634101bc988641ed14af1c"
    sha256 cellar: :any, arm64_tahoe:       "02c68863ec2f5ff93504e1fdf7f2af4b78f2924489d7d793b02aaa756d01348b"
    sha256 cellar: :any, arm64_sequoia:     "c61a3b4caad9b151297eedb4ade6d47c1c2bdbbf638e9511d3cf1be8ebbe8522"
    sha256 cellar: :any, arm64_linux:       "4a0b7ae1db899b2f7f822472ae6b9fa377f44dcd6d13a3f686be4edb6143288c"
    sha256 cellar: :any, x86_64_linux:      "c6718fff0640e8c10277b189796346faffb26289f4b5a01b659f654db646db75"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

  pypi_packages package_name: "robotcode[all]"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
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
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/0a/e7/bb605a7bab2d8425a64b3fa762b39dc1bf1c7e3f11ba6fb5413d6db0ff8c/msgpack-1.2.3.tar.gz"
    sha256 "32edb81a2b5eb7cd7c9d941b2bfbbb082fd2cd09e0e725930316af6b708db186"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/80/a8/66d45abadff219e36e2a824181b8f6a67e7ed4572934d6252c71c29d5731/platformdirs-4.13.0.tar.gz"
    sha256 "1aa0b0d3f224c1f07c295121e312a5a24a180d6ae5a8425ea1784b3e3863e9c0"
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
    url "https://files.pythonhosted.org/packages/66/77/5f60e5619082d387971d111c1354f1f529d2959ee742877982002d38d53d/robotframework-7.5.tar.gz"
    sha256 "ff6233ff752a200ece4d0a6c59f6f9f7d0e96dcff0a7a3458296b997b812482e"
  end

  resource "robotframework-robocop" do
    url "https://files.pythonhosted.org/packages/21/a6/3dee138281a211bb44cff4f3e88a48a1a0e0b782f1746a46b2da1970fa87/robotframework_robocop-9.1.0.tar.gz"
    sha256 "1204a8645a48eaba0a7779035a8af3419a681fa3d511b875f57856e5357fe749"
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
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
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

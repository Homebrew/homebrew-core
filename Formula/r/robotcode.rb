class Robotcode < Formula
  include Language::Python::Virtualenv

  desc "Ultimate Robot Framework Toolset"
  homepage "https://robotcode.io"
  url "https://files.pythonhosted.org/packages/32/8d/ec077aa7a3f843a19db1bfdf438f62b635571f104e68fc7bf2d51a286c7a/robotcode-2.8.0.tar.gz"
  sha256 "da7e84dd7216a4c01b67168b5b299a0964c062a8a812adfc044ae1720e34f773"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "33b61e981d171a07a984e549b5a44403d52f7fffe9a73ce47575572e3ef7a2e1"
    sha256 cellar: :any, arm64_tahoe:       "66cbe35468c73dbd6ac996b4a5869b1cf1ded43630e11ec34075d47c88e77ceb"
    sha256 cellar: :any, arm64_sequoia:     "f3949cc0ecf675b9be9da4c8139b03397df8cdc96e07fcf7f873e00726fc1007"
    sha256 cellar: :any, arm64_linux:       "65ef3c3d19f94bb9bfc02aca1bddf753d9f58c801c517a8df565b0849052294e"
    sha256 cellar: :any, x86_64_linux:      "34cdfb02ccf6e03c70fd15dfd635a672d541d2075e05a467e5ca2933a5cbc84c"
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
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/bf/db/7fc19e6f2dc92a966727031389fc2e08b558f0f25eb7403c1119ad4713cd/pluggy-1.7.0.tar.gz"
    sha256 "d1eaa46ebb595891b860ab086b4d09c8588af65ebd4361b8e8f4bb8920b90ba8"
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
    url "https://files.pythonhosted.org/packages/2c/29/78f824beebb1c43ba0a910a5c0463afe57f75c7b5ad9a032e31380020db7/robotcode_analyze-2.8.0.tar.gz"
    sha256 "3ad7c1fc65298903154865583879a4be42b14ac3a72eee30a69cb817b5b95678"
  end

  resource "robotcode-core" do
    url "https://files.pythonhosted.org/packages/12/ea/477274ba4e6a26b0b2258ba989d75d624c9d6a8bcd4ea8b3108e28c7009f/robotcode_core-2.8.0.tar.gz"
    sha256 "31b5a38edba888adbd31ab1bd54d5cab9a5c049a0f124b5c9f379ba6db99be43"
  end

  resource "robotcode-debugger" do
    url "https://files.pythonhosted.org/packages/cd/c6/d2a1eff9e6de6ab11399a42050df5e6622e7e728d44f112ed861330c228b/robotcode_debugger-2.8.0.tar.gz"
    sha256 "e7ddb923c1281327b85bb21ef11efc8a3086ec14fef1010d0056911efce9444b"
  end

  resource "robotcode-jsonrpc2" do
    url "https://files.pythonhosted.org/packages/3f/ea/13eb1a99b2c2491e74092d63a20d523bea702821547a9f582f9c904daddb/robotcode_jsonrpc2-2.8.0.tar.gz"
    sha256 "05c9e86e0745ed45a7ff12563134a4a52b4575e8708d60bf3c8f8c79ae6fa3b2"
  end

  resource "robotcode-language-server" do
    url "https://files.pythonhosted.org/packages/e1/c0/5b2c9869e1295d2516fdb610e7b153ce4c9b5d82121becf55d09291fc6bc/robotcode_language_server-2.8.0.tar.gz"
    sha256 "3938b3c5a00008cef6db642d0f605d19fb26cddd5b4cae834069544be3b7bb87"
  end

  resource "robotcode-modifiers" do
    url "https://files.pythonhosted.org/packages/e3/8b/2d7bcc3b9b4af0073440cf18bf92d5b0d62da1c1c3c9d7bea26a31c6ac9d/robotcode_modifiers-2.8.0.tar.gz"
    sha256 "667eb5253e3bad6207a6655dfccd05830a09a99c6cb742ad7ec72d8d1fb1caf0"
  end

  resource "robotcode-plugin" do
    url "https://files.pythonhosted.org/packages/eb/ba/64279b9533afdc310247da11ac76c6c905bc5007b355555c71a9398940a2/robotcode_plugin-2.8.0.tar.gz"
    sha256 "7e62970534ad01a126546d132f4cc6fb613a75840a7a2b0bffc408b460a94ba5"
  end

  resource "robotcode-repl" do
    url "https://files.pythonhosted.org/packages/19/b1/b4a9cfdae11fbbd6a4d836a66362e20f21581416506c71305a32e8223e15/robotcode_repl-2.8.0.tar.gz"
    sha256 "cec9bf6b0560a2b806a90e9c27a63071779fdf810c8ba0f0894e8c1d7323a81d"
  end

  resource "robotcode-repl-server" do
    url "https://files.pythonhosted.org/packages/44/4b/3ba0f9f3556dfb5020c31e768b72404cb90c685395e2f8dd8b00e6cb897c/robotcode_repl_server-2.8.0.tar.gz"
    sha256 "623b39cb3f51ab1d663e5df4b80bac7d7e2dab18f8bc3190fa348f817ebff0dd"
  end

  resource "robotcode-robot" do
    url "https://files.pythonhosted.org/packages/0b/92/2605eabc70b037e284e8abeecd5137391aadb43ceb6eab2420d5fc631e20/robotcode_robot-2.8.0.tar.gz"
    sha256 "438376896040757429f5be40b1de58f54286f1769e41229c93213912183a8031"
  end

  resource "robotcode-runner" do
    url "https://files.pythonhosted.org/packages/49/60/c9436ed4b30e6b99dd1496eca0ac816dea58fa016fa7cf810c0cebd41147/robotcode_runner-2.8.0.tar.gz"
    sha256 "62b1fad01bb71c8e2db7787c36a07b45066c8479fa494d0b8e39c67aedc5a91e"
  end

  resource "robotframework" do
    url "https://files.pythonhosted.org/packages/66/77/5f60e5619082d387971d111c1354f1f529d2959ee742877982002d38d53d/robotframework-7.5.tar.gz"
    sha256 "ff6233ff752a200ece4d0a6c59f6f9f7d0e96dcff0a7a3458296b997b812482e"
  end

  resource "robotframework-robocop" do
    url "https://files.pythonhosted.org/packages/24/90/248070b2def441f19f8f936024c62ebbdb90c1a610f5b5470f0ea1118d9c/robotframework_robocop-9.1.2.tar.gz"
    sha256 "ce93c6a46434bd5e2a40f6fec81514cb9fe1c9ee4fa97db03d1d3bed541688b3"
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
    url "https://files.pythonhosted.org/packages/ea/01/e5ac23733628a6bbb91913a765fcf55ee8070d8d991bc88fdaaf805052c7/wcwidth-0.9.4.tar.gz"
    sha256 "fd8d57d3cdfe570e3265c8fab1885c24e34ef40889c0759c0c304a19e9835954"
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

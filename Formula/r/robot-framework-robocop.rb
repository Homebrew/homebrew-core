class RobotFrameworkRobocop < Formula
  include Language::Python::Virtualenv

  desc "Static code analysis tool (linter) and code formatter for Robot Framework"
  homepage "https://robocop.dev"
  url "https://files.pythonhosted.org/packages/68/0e/fae2dbcee0bd3e05a9281fc8cada68c791bc6c1cc646f95ede15a6151b93/robotframework_robocop-9.2.0.tar.gz"
  sha256 "d74f493ef5f53a9c51c9f36b7bb79b7eb716b951a1f68a82632924d651077464"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b73de8c239b2a906f2c9148d8e2444aacc863f1a64aea822577460d9e51038cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "83233126d3bd6fe788c3d75ad16339a2583b2b969065d40abc6dfdd57cf1358d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0943d24f92738209464c3c98d67bc3ad0746d2cb006494dd62e65e8cd381c524"
    sha256 cellar: :any,                 arm64_linux:       "61b1361c09d644afc2707267e15082516508646ccc7160497d8f108a415b5bb3"
    sha256 cellar: :any,                 x86_64_linux:      "b4b3bd271accdade8e4aa831330327def925a75005bcc3dfae89a191b57c1c66"
  end

  depends_on "python@3.15"

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
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
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "robotframework" do
    url "https://files.pythonhosted.org/packages/99/82/c7e3f8acb173c63e17cbdffdadf95a55520c0139cc548ce9ac963424361b/robotframework-7.5.1.tar.gz"
    sha256 "00f63dc7b0477a137f8a9c1f2e14db8084a4d187a76f3fec6c2567875c32b932"
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
    url "https://files.pythonhosted.org/packages/ad/8f/21021859316f44289101638dc74d82e13d722d8533e4b8708a3ab7c8461a/typer-0.28.0.tar.gz"
    sha256 "69ab84ef79fd601cff071bbd2566d855ecadfd93adbc4b3360b9924359bdd857"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  def install
    virtualenv_install_with_resources

    # The `robocop-mcp` server needs the optional `mcp` extra, which is not installed.
    (bin/"robocop-mcp").unlink

    generate_completions_from_executable(bin/"robocop", shell_parameter_format: :typer)
  end

  test do
    (testpath/"brew.robot").write <<~EOT
      *** Test Cases ***
      Homebrew Test
          [Documentation]  Test case in Homebrew formula
          Log  Hello from Homebrew!
    EOT
    assert_match "Missing documentation in suite",
      shell_output("#{bin}/robocop check #{testpath}/brew.robot", 1)
    assert_match "1 file would be reformatted",
      shell_output("#{bin}/robocop format --check #{testpath}/brew.robot", 1)
  end
end

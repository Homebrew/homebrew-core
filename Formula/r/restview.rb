class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/3d/d4/36ed06051e9702d3dae5f7bb0296b79b18621ff5a1bf43247509cbfeff8d/restview-3.0.2.tar.gz"
  sha256 "8b4d75a0bed76b67b456ef7011f4eb6c98a556c9f837642df2202c7312fccc1a"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/mgedmin/restview.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1748f0fcbf60c7a1b82fd8ef7fbc89e336d4dfe198d03cacc5bb484f1d2540ed"
  end

  depends_on "python@3.15"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/48/3c/e12ac860709702bd5ebeb9b56a4fe334f1001246ee1b8f2b7ee28912df7d/bleach-6.4.0.tar.gz"
    sha256 "4202482733d85cedd04e59fcb2f89f4e4c7c385a78d3c3c23c30446843a37452"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/39/a4/5180d9afc57e8fca05601dd652bdff19604c218814037fe90ffc7625a50a/docutils-0.23.tar.gz"
    sha256 "746f5060322511280a1e50eb76846ed6bf2342984b2ac04dc42caa1a8d78799e"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/15/4e/0ffa80eb3e0d0fcc0c6b901b36d4faa11c47d10b9a066fdd42f24c7e646a/readme_renderer-36.0.tar.gz"
    sha256 "f71aeef9a588fcbed1f4cc001ba611370e94a0cd27c75b1140537618ec78f0a2"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/d5/a0/8fd707bcb776a7be556bad06a2ea5fb9bd519df78ef8e26f70ccf0f38bff/webencodings-0.6.1.tar.gz"
    sha256 "565f9ad031c702dae404e27a099e3e09186a3ab1b9520f06d215502b651fd910"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.rst").write <<~RST
      Lists
      -----

      Here we have a numbered list

      1. Four
      2. Five
      3. Six
    RST

    port = free_port
    pid = spawn bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
    begin
      output = shell_output("curl --silent --retry 5 --retry-connrefused 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

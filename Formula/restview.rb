class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/df/57/c39171d211168008153b00c0dd9b873afb6d9e76eecbd3496c86aeaac8bf/restview-3.0.0.tar.gz"
  sha256 "2b989610aaed2fd42da64f6cdc539cf3ee70ce370bcba872db72421ad515dd1e"
  license "GPL-3.0"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53bf1c94ce5dd28f537d6e0391c4d45a598d86711ae85f1c89012d6b823ec24e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17c48b5838702d58ab32bdb41af4ccd1544754a34118fba2901c1664507aba7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f50937f4bd21ce1666c20e43f9f81b4da81d105d896e37fc0e78df34b1315e70"
    sha256 cellar: :any_skip_relocation, ventura:        "9cee8d2afdf1816113f109cf6cef6493fa397e312520c224bf3fac59cc0cf14b"
    sha256 cellar: :any_skip_relocation, monterey:       "301d16ee4e9b3cfe46d31dee3ccd535e783b1743dd9e5754ad4586d49cc6a1c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd30574a3c873904c59cb16a3ec72e21a14b75f9c8fd88372dea94d239cb0cab"
    sha256 cellar: :any_skip_relocation, catalina:       "8992fbee2f64fb5d41ed2f0fb04c8d37bc6914791187582a66b97a1588c99d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "762d85d4f7157aaf45a4e37d453d5fd844652434a65017331ece19d6f2c0c4f7"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/c2/5d/d5d45a38163ede3342d6ac1ca01b5d387329daadf534a25718f9a9ba818c/bleach-5.0.1.tar.gz"
    sha256 "0d03255c47eb9bd2f26aa9bb7f2107732e7e8fe195ca2f64709fcf3b0a4a085c"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/81/c3/d20152fcd1986117b898f66928938f329d0c91ddc47f081c58e64e0f51dc/readme_renderer-37.3.tar.gz"
    sha256 "cd653186dfc73055656f090f227f5cb22a046d7f71a841dfa305f55c9a513273"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"sample.rst").write <<~EOS
      Lists
      -----

      Here we have a numbered list

      1. Four
      2. Five
      3. Six
    EOS

    port = free_port
    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 3
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li><p>Four</p></li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

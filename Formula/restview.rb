class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/df/57/c39171d211168008153b00c0dd9b873afb6d9e76eecbd3496c86aeaac8bf/restview-3.0.0.tar.gz"
  sha256 "2b989610aaed2fd42da64f6cdc539cf3ee70ce370bcba872db72421ad515dd1e"
  license "GPL-3.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "000e31325b6b26053ef672c5f3c7069c8c3d92a743a0abdaed70cffac99a1449"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d86173a917426e0bb453075eba8ca04afcb79d0b7ffb33fe5f040a8018ecb23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "efa0988f559e113c197fe3c3a60c89a3ec839f5406f9459a1367aaf231e37bdb"
    sha256 cellar: :any_skip_relocation, monterey:       "0228468855cd38a9121c45ebfe90f9d3af7c0d4d8eaa8aa6bc01838044bb666c"
    sha256 cellar: :any_skip_relocation, big_sur:        "145adda86b89dac5b30c17ce7d78e4cef7c069f7dac5a511e6bb10115a9d4b2e"
    sha256 cellar: :any_skip_relocation, catalina:       "6cdcb042f469581a68f633f748c79dc0438acc63a8546671c6f149cac56026a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b34dbb330e8d4795e2b92c283aac6fa55fb6fdc170be3a6850e71d7465e6a32"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/c2/5d/d5d45a38163ede3342d6ac1ca01b5d387329daadf534a25718f9a9ba818c/bleach-5.0.1.tar.gz"
    sha256 "0d03255c47eb9bd2f26aa9bb7f2107732e7e8fe195ca2f64709fcf3b0a4a085c"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
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

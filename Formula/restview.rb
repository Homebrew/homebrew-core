class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/df/57/c39171d211168008153b00c0dd9b873afb6d9e76eecbd3496c86aeaac8bf/restview-3.0.0.tar.gz"
  sha256 "2b989610aaed2fd42da64f6cdc539cf3ee70ce370bcba872db72421ad515dd1e"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75222c9a80589397d43420afc5cba5d73976a93d8233b82285f778c7ac57dc12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41ab5c0a14611252d535453bd87c54c6bf0070d3ee786bf39c171dff8cba23ad"
    sha256 cellar: :any_skip_relocation, monterey:       "3ea3915d3a778e23677a900c3aab7425b028468150e266e74e5b6adb1e083a05"
    sha256 cellar: :any_skip_relocation, big_sur:        "c897987aa35d178a5c1b7a9d4bc1fc6dcad8a094d850e245f91c82ace51d410d"
    sha256 cellar: :any_skip_relocation, catalina:       "892229bead0eeddd16397bd8f6adae818bed7269a1f8ca89e7cc67c1224c08bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04ddf5e1109e7978a814dfa5824461b7e70679754a3aba9b08e2618b87504ee4"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6a/a3/217842324374fd3fb33db0eb4c2909ccf3ecc5a94f458088ac68581f8314/bleach-4.1.0.tar.gz"
    sha256 "0900d8b37eba61a802ee40ac0061f8c2b5dee29c1927dd1d233e075ebf5a71da"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/57/b1/b880503681ea1b64df05106fc7e3c4e3801736cf63deffc6fa7fc5404cf5/docutils-0.18.1.tar.gz"
    sha256 "679987caf361a7539d76e584cbeddc311e3aee937877c87346f31debc63e9d06"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/5a/3e/e368a390fe7ffcfd0bfd2ec5220ece8907b4b79d0e9f1356c7ae27f03e54/readme_renderer-32.0.tar.gz"
    sha256 "b512beafa6798260c7d5af3e1b1f097e58bfcd9a575da7c4ddd5e037490a5b85"
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
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

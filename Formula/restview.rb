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

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
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

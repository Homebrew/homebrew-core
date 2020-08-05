class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://github.com/mgedmin/restview/archive/2.9.2.tar.gz"
  sha256 "155a5744111d3d1f9e7903f4445ff41c04b42c0be29705f57fb98b3d33b283bd"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "5ffb757282d3542b8a7b1059e56f3bbf0a952c43c4a630a4aec43050cdf35285" => :catalina
    sha256 "126c2097c8981aba77b79069e90803191677fc894f78664eaab9926603766931" => :mojave
    sha256 "d91b7a7a04bd5bac8b29cb581bab4929488d0b1f3cbb084ceaf9b49996913099" => :high_sierra
  end

  depends_on "python@3.8"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/a9/ac/dc881fca3ac66d6f2c4c3ac46633af4e9c05ed5a0aa2e7e36dc096687dd7/bleach-3.1.5.tar.gz"
    sha256 "3c4c520fdb9db59ef139915a5db79f8b51bc2a7257ea0389f30c846883430a4b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/37/83e3f492eb52d771e2820e88105f605335553fe10422cba9d256faeb1702/packaging-20.3.tar.gz"
    sha256 "3c292b474fda1671ec57d46d739d072bfd495a4f51ad01a055121d81e952b7a3"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/13/d6/8e241e4e40404a1f83567d6a29798abee0b9b50b08c8efc815ce11c41df9/readme_renderer-26.0.tar.gz"
    sha256 "cbe9db71defedd2428a1589cdc545f9bd98e59297449f69d721ef8f1cfced68d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "sample" do
    url "https://raw.githubusercontent.com/mgedmin/restview/140e23ad6604d52604bc11978fd13d3199150862/sample.rst"
    sha256 "5a15b5f11adfdd5f895aa2e1da377c8d8d0b73565fe68f51e01399af05612ea3"
  end

  def install
    venv = virtualenv_create(libexec, "python3.8")

    res = resources.reject { |r| r.name == "sample" }
    venv.pip_install res

    venv.pip_install_and_link buildpath
  end

  test do
    testpath.install resource("sample")

    port = free_port
    begin
      pid = fork do
        exec bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      end
      sleep 3
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/e6/40/b4ef5c90297b9d37248090b9fde3a9aa1ef25e87ebd17b363760fec39a78/restview-2.9.2.tar.gz"
  sha256 "790097eb587c0465126dde73ca06c7a22c5007ce1be4a1de449a13c0767b32dc"
  license "GPL-3.0"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44ac7dd627e9564db2ea168ebab81fe6a857603ccb9400e3259b99e4e84ff6dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cb2eeee507bc57c0b8ea4daaa09beb5953ed23c6368279e0965d5db83da851d6"
    sha256 cellar: :any_skip_relocation, monterey:       "c055e05f3a46f9ea28a97036987db6caca52c91412f34a20b7f4f9db45e2c1ba"
    sha256 cellar: :any_skip_relocation, big_sur:        "9470d4f0e710da0bda1cb188f6a26ea8300fad4273c67d8362b95655a3131436"
    sha256 cellar: :any_skip_relocation, catalina:       "51774d5ba45376854bbccc90a94252cedc5c7e22efbe933305aa55c077a755ed"
    sha256 cellar: :any_skip_relocation, mojave:         "9afe08d8d8f8f4cd5a64e2de7af17eff2de637442feccdedb36320afb8a0deb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "deffb0171b3411a93bac2ffa760adbcdf7939592f052c1bed930cc21946f05cf"
  end

  depends_on "python@3.9"

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
    venv = virtualenv_create(libexec, "python3.9")

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

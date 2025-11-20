class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/3d/d4/36ed06051e9702d3dae5f7bb0296b79b18621ff5a1bf43247509cbfeff8d/restview-3.0.2.tar.gz"
  sha256 "8b4d75a0bed76b67b456ef7011f4eb6c98a556c9f837642df2202c7312fccc1a"
  license "GPL-3.0-or-later"
  head "https://github.com/mgedmin/restview.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f2254c6aeaa7538ce7a7885a2054fbeee886748c1b28aa98af5d73217281389a"
  end

  depends_on "python@3.14"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/76/9a/0e33f5054c54d349ea62c277191c020c2d6ef1d65ab2cb1993f91ec846d1/bleach-6.2.0.tar.gz"
    sha256 "123e894118b8a599fd80d3ec1a6d4cc7ce4e5882b1317a7e1ba69b56e95f991f"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/4a/c0/89fe6215b443b919cb98a5002e107cb5026854ed1ccb6b5833e0768419d1/docutils-0.22.2.tar.gz"
    sha256 "9fdb771707c8784c8f2728b67cb2c691305933d68137ef95a75db5f4dfbc213d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/15/4e/0ffa80eb3e0d0fcc0c6b901b36d4faa11c47d10b9a066fdd42f24c7e646a/readme_renderer-36.0.tar.gz"
    sha256 "f71aeef9a588fcbed1f4cc001ba611370e94a0cd27c75b1140537618ec78f0a2"
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
      pid = spawn bin/"restview", "--listen=#{port}", "--no-browser", "sample.rst"
      sleep 15
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

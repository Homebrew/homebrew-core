class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/3d/d4/36ed06051e9702d3dae5f7bb0296b79b18621ff5a1bf43247509cbfeff8d/restview-3.0.2.tar.gz"
  sha256 "8b4d75a0bed76b67b456ef7011f4eb6c98a556c9f837642df2202c7312fccc1a"
  license "GPL-3.0-or-later"
  head "https://github.com/mgedmin/restview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5207c409839c90c9be97716a6349e1f988af6a3ad9a74eabab636ac3f91c4c88"
  end

  depends_on "python@3.13"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6d/10/77f32b088738f40d4f5be801daa5f327879eadd4562f36a2b5ab975ae571/bleach-6.1.0.tar.gz"
    sha256 "0a31f1837963c41d46bbf1331b8778e1308ea0791db03cc4e7357b97cf42a8fe"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/ed/aefcc8cd0ba62a0560c3c18c33925362d46c6075480bfa4df87b28e169a9/docutils-0.21.2.tar.gz"
    sha256 "3a6b18732edf182daa3cd12775bbb338cf5691468f91eeeb109deff6ebfa986f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "readme-renderer" do
    url "https://files.pythonhosted.org/packages/15/4e/0ffa80eb3e0d0fcc0c6b901b36d4faa11c47d10b9a066fdd42f24c7e646a/readme_renderer-36.0.tar.gz"
    sha256 "f71aeef9a588fcbed1f4cc001ba611370e94a0cd27c75b1140537618ec78f0a2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
      sleep 5
      output = shell_output("curl -s 127.0.0.1:#{port}")
      assert_match "<p>Here we have a numbered list</p>", output
      assert_match "<li>Four</li>", output
    ensure
      Process.kill("TERM", pid)
    end
  end
end

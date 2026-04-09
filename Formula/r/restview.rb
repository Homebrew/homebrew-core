class Restview < Formula
  include Language::Python::Virtualenv

  desc "Viewer for ReStructuredText documents that renders them on the fly"
  homepage "https://mg.pov.lt/restview/"
  url "https://files.pythonhosted.org/packages/3d/d4/36ed06051e9702d3dae5f7bb0296b79b18621ff5a1bf43247509cbfeff8d/restview-3.0.2.tar.gz"
  sha256 "8b4d75a0bed76b67b456ef7011f4eb6c98a556c9f837642df2202c7312fccc1a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/mgedmin/restview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "973609bbf38eb5733fed3c1d7a1051e10d519b1b0514a9197a52530f32bbf6a1"
  end

  depends_on "python@3.14"

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/07/18/3c8523962314be6bf4c8989c79ad9531c825210dd13a8669f6b84336e8bd/bleach-6.3.0.tar.gz"
    sha256 "6f3b91b1c0a02bb9a78b5a454c92506aa0fdf197e1d5e114d2e00c6f64306d22"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
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

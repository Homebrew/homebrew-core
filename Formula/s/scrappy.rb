class Scrappy < Formula
  include Language::Python::Virtualenv

  desc "Python utility for scraping manuals, documents, and other sensitive PDFs"
  homepage "https://github.com/RoseSecurity/ScrapPY"
  url "https://github.com/RoseSecurity/ScrapPY/archive/refs/tags/0.1.0.tar.gz"
  sha256 "716d4e798b99286ca007903760ad0a70a40960b3fedc62e6bcdd739784a1a0c7"
  license "Apache-2.0"
  head "https://github.com/RoseSecurity/ScrapPY.git", branch: "main"

  depends_on "libcython" => :build
  depends_on "meson" => :build
  depends_on "meson-python" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "pythran" => :build
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"

  resource "pandas" do
    url "https://files.pythonhosted.org/packages/3a/6e/6c9c197ec2da861ea8c9c6848f0f887b7563f16e607bc6a35506af677f30/pandas-2.1.2.tar.gz"
    sha256 "52897edc2774d2779fbeb6880d2cfb305daa0b1a29c16b91f531a18918a6e0f3"
  end

  resource "PyPDF" do
    url "https://files.pythonhosted.org/packages/bc/da/bd1326fa03e4df068d105e5aa95a7ddd99a1e8b5c73992a62ab8e3fc1b71/pypdf-3.17.0.tar.gz"
    sha256 "9fab275fea57c9e5b2416035d13d867a459ebe36294a4c39a3d0bb45a7404bad"
  end

  def python3
    "python3.11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"ScrapPY.py", "--help"
  end
end

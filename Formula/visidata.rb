class Visidata < Formula
  include Language::Python::Virtualenv
  desc "Terminal utility for exploring and arranging tabular data"
  homepage "http://visidata.org"
  url "https://github.com/saulpw/visidata/archive/v0.98.1.tar.gz"
  sha256 "853d19ee2a74f986feeb3fc08656a349a4b26ee090b595d41f69bce777dd3907"
  head "https://github.com/saulpw/visidata.git"

  depends_on :python3

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/22/28/a99c42aea746e18382ad9fb36f64c1c1f04216f41797f2f0fa567da11388/et_xmlfile-1.0.1.tar.gz"
    sha256 "614d9722d572f6246302c4491846d2c393c199cfa4edc9af593437691683335b"
  end

  resource "jdcal" do
    url "https://files.pythonhosted.org/packages/9b/fa/40beb2aa43a13f740dd5be367a10a03270043787833409c61b79e69f1dfd/jdcal-1.3.tar.gz"
    sha256 "b760160f8dc8cc51d17875c6b663fafe64be699e10ce34b6a95184b5aa0fdc9e"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/8c/75/c4e557207c7ff3d217d002d4fee32b4e5dbfc5498e2a2c9ce6b5424c5e37/openpyxl-2.4.9.tar.gz"
    sha256 "95e007f4d121f4fd73f39a6d74a883c75e9fa9d96de91d43c1641c103c3a9b18"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/86/cf/bb010f16cefa8f26ac9329ca033134bcabc7a27f5c3d8de961bacc0f80b3/xlrd-1.1.0.tar.gz"
    sha256 "8a21885513e6d915fe33a8ee5fdfa675433b61405ba13e2a69e62ee36828d7e2"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install_and_link buildpath
    man1.install "visidata/man/vd.1"
    Language::Python.each_python(build) do |_, version|
      bundle_path = libexec/"lib/python#{version}/site-packages"
      bundle_path.mkpath
      ENV.prepend_path "PYTHONPATH", bundle_path
      (lib/"python#{version}/site-packages/homebrew-visidata-bundle.pth").write "#{bundle_path}\n"
    end
  end

  test do
    system "#{libexec}/bin/python3", "-c", "import visidata"
  end
end

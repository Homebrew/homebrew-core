class Visidata < Formula
  include Language::Python::Virtualenv
  desc "Terminal utility for exploring and arranging tabular data"
  homepage "http://visidata.org"
  url "https://files.pythonhosted.org/packages/7a/35/d05bcb2eac76b244c117e1529ffdb2a2869d26d5d0a22c3d995d64902e41/visidata-0.99.tar.gz"
  sha256 "52677c5886d6e769e34aeb6ffb75ad18ce633ac3bf005b8c7d99e8cd1474330e"
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

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e1/4c/d83979fbc66a2154850f472e69405572d89d2e6a6daee30d18e83e39ef3a/lxml-4.1.1.tar.gz"
    sha256 "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
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

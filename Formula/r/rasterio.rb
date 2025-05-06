class Rasterio < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geospatial raster datasets"
  homepage "https://rasterio.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/de/19/ab4326e419b543da623ce4191f68e3f36a4d9adc64f3df5c78f044d8d9ca/rasterio-1.4.3.tar.gz"
  sha256 "201f05dbc7c4739dacb2c78a1cf4e09c0b7265b0a4d16ccbd1753ce4f2af350a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "78c22b105ddfe5627305ac933da41a879b078f0678696837dc34453bd4a9aaf1"
    sha256 cellar: :any,                 arm64_sonoma:  "c0772d77c4daf508c53825cba58a5e6619ca380b05a8033a21176f7ffc97967d"
    sha256 cellar: :any,                 arm64_ventura: "a7f901287973fee54bbbe87c7a98f71cd790e2b941c87118469cc45d6768062d"
    sha256 cellar: :any,                 sonoma:        "08dcd483af2d7e48cebf0bdb69c0e881d77eb8cdc00f131dd3ffb7e27fb112fa"
    sha256 cellar: :any,                 ventura:       "b11fc4d43981cd10e892d7a023ad165697ef0205d3a8d29ce5ba4fcd8d29d604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fc1257c4bebaf72e821fee8717d3df235bc85ce4fa2f822e2b0c2f64a2d9987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb48e6529ce61237e5da0d9f80b495289a53cc7e772d6ed4cc3af55a9f9f0de5"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi"
  depends_on "gdal"
  depends_on "numpy"
  depends_on "python@3.13"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "rio", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  resource "affine" do
    url "https://files.pythonhosted.org/packages/69/98/d2f0bb06385069e799fc7d2870d9e078cfa0fa396dc8a2b81227d0da08b9/affine-2.4.0.tar.gz"
    sha256 "a24d818d6a836c131976d22f8c27b8d3ca32d0af64c1d8d29deb7bafa4da1eea"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "cligj" do
    url "https://files.pythonhosted.org/packages/ea/0d/837dbd5d8430fd0f01ed72c4cfb2f548180f4c68c635df84ce87956cff32/cligj-0.7.2.tar.gz"
    sha256 "a4bc13d623356b373c2c27c53dbd9c68cae5d526270bfa71f6c6fa69669c6b27"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8b/1a/3544f4f299a47911c2ab3710f534e52fea62a633c96806995da5d25be4b2/pyparsing-3.2.1.tar.gz"
    sha256 "61980854fd66de3a90028d679a954d5f2623e83144b5afe5ee86f43d762e5f0a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"rio", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    resource "test_file" do
      url "https://github.com/rasterio/rasterio/raw/refs/heads/main/tests/data/red.tif"
      sha256 "faff88a7935f2993ad2a24f572bb73c4d1fa4c5159377f4d9742583ae7c4c52b"
    end

    testpath.install resource("test_file")

    output = shell_output("#{bin}/rio info red.tif")
    assert_equal 16, JSON.parse(output)["blockxsize"]
  end
end

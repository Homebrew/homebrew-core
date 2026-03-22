class Rasterio < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geospatial raster datasets"
  homepage "https://rasterio.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/f6/88/edb4b66b6cb2c13f123af5a3896bf70c0cbe73ab3cd4243cb4eb0212a0f6/rasterio-1.5.0.tar.gz"
  sha256 "1e0ea56b02eea4989b36edf8e58a5a3ef40e1b7edcb04def2603accd5ab3ee7b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "39ba5bbf4162c1dbf507609cc7cedb2cc1930bc7137ee29d7d75a418bb92b702"
    sha256 cellar: :any, arm64_sequoia: "cf94805c317c704e5463088fcfa2e7abafa10f57c665cdbd5443de6be2b25993"
    sha256 cellar: :any, arm64_sonoma:  "adb34e481a937554d06535b9cac832e55af998111d31c12a2e67bf66f15a8db8"
    sha256 cellar: :any, sonoma:        "2173a0213b06de5ee024e074236b00cbdfc4615745a3079be341b0448e3e8680"
    sha256               arm64_linux:   "97f0e576838ae48c4f5aed779ba4ed53e4a6fa9ec647d2c126d6b1697cc10390"
    sha256               x86_64_linux:  "3f62b2e3268ad577e25f8d8a88733c7a5f472dfc292daffee1cd46ff7a774236"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "certifi" => :no_linkage
  depends_on "gdal"
  depends_on "numpy"
  depends_on "python@3.14"

  on_linux do
    depends_on "patchelf" => :build
  end

  conflicts_with "rio-terminal", because: "both install `rio` binaries"
  conflicts_with cask: "rio", because: "both install `rio` binaries"

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "affine" do
    url "https://files.pythonhosted.org/packages/69/98/d2f0bb06385069e799fc7d2870d9e078cfa0fa396dc8a2b81227d0da08b9/affine-2.4.0.tar.gz"
    sha256 "a24d818d6a836c131976d22f8c27b8d3ca32d0af64c1d8d29deb7bafa4da1eea"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "cligj" do
    url "https://files.pythonhosted.org/packages/ea/0d/837dbd5d8430fd0f01ed72c4cfb2f548180f4c68c635df84ce87956cff32/cligj-0.7.2.tar.gz"
    sha256 "a4bc13d623356b373c2c27c53dbd9c68cae5d526270bfa71f6c6fa69669c6b27"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/33/c1/1d9de9aeaa1b89b0186e5fe23294ff6517fce1bc69149185577cd31016b2/pyparsing-3.3.1.tar.gz"
    sha256 "47fad0f17ac1e2cad3de3b458570fbc9b03560aa029ed5e16ee5554da9a2251c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"rio", shell_parameter_format: :click)
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

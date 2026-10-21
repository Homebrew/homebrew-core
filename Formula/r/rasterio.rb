class Rasterio < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geospatial raster datasets"
  homepage "https://rasterio.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/51/90/bd0a124e164f5fe776084c9731b43ab136b31281a18608e617cdb5f2be70/rasterio-1.5.2.tar.gz"
  sha256 "e65a15b7bd22ce8f8ce8159856669dc9fafabf66cde6156e8f8e71d55abcd515"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "086c2059b0c3ddada92a80412f2e33cb94d8e94a9788f8e8b8bc967d76132425"
    sha256 cellar: :any, arm64_tahoe:       "4bd0cf8616b5d4a49ef34a5d07a864fc27ad7560b4eda820b6046618668f5ba3"
    sha256 cellar: :any, arm64_sequoia:     "dc57ce0f611a49d0ad8a341a0fa98ce0c650f0a941e350401dafe6184787f1da"
    sha256 cellar: :any, arm64_linux:       "4b32288d2d867f47f4bd5299c4ea4f15117d4764775ee688c10fc2bfe9461467"
    sha256 cellar: :any, x86_64_linux:      "28794166c990e7ac3582782ebfabc4a3f52625998c41bfa9617e169b26a828b6"
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

  pypi_packages exclude_packages: %w[certifi numpy]

  resource "affine" do
    url "https://files.pythonhosted.org/packages/63/e9/4a4480601992a529c5d0f406605f70ca59aeaef4a6f5ba8905cfde217d0b/affine-3.0.1.tar.gz"
    sha256 "e1b3c38c5d4d3ef5024a182a6d1bf1e0c51ab221825781c741aeb4d0c079a7e2"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
  end

  resource "test_file", :test do
    url "https://github.com/rasterio/rasterio/raw/refs/heads/main/tests/data/red.tif"
    sha256 "faff88a7935f2993ad2a24f572bb73c4d1fa4c5159377f4d9742583ae7c4c52b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"rio", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rio --version")

    testpath.install resource("test_file")

    output = shell_output("#{bin}/rio info red.tif")
    assert_equal 16, JSON.parse(output)["blockxsize"]
  end
end

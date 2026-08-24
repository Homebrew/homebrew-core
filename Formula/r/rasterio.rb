class Rasterio < Formula
  include Language::Python::Virtualenv

  desc "Reads and writes geospatial raster datasets"
  homepage "https://rasterio.readthedocs.io/en/stable/"
  url "https://files.pythonhosted.org/packages/1d/1a/ee73b447f1623a6bb6490af08d4bbed3fb6e38b0adc54553a0d244d4103a/rasterio-1.5.1.tar.gz"
  sha256 "c1b6ae15f4ccad704f1fe8417da5c2250145c7bcdb91acb53833bf5aefdd9e48"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7d2c360110f48c18138f42d686471f7e0dddbebed424d4bb7bd82a7826ba7fbe"
    sha256 cellar: :any, arm64_sequoia: "ee9e03924950759ed47ad4907c73a5baf9172df087cce2a312efbeb134281571"
    sha256 cellar: :any, arm64_sonoma:  "f9c5ddb3b4cc768bdef2626ea64a98c4121558244fe6a472ce8c75ed213d68f9"
    sha256 cellar: :any, sonoma:        "b095affc6058ade8559aa842a106a00885f3b20ebe762b6d1c9e8e5e9bb4a1a1"
    sha256               arm64_linux:   "27126bb3eff5b0acf5b62d901d26b405fb99ad86ae8f8ba5589b8d98b1aeb87f"
    sha256               x86_64_linux:  "420b8722ac51c8a79a9dad9604533bace3903e3215aa6620719be3b340e70402"
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
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
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

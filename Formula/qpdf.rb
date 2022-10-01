class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.1.1/qpdf-11.1.1.tar.gz"
  sha256 "25e8ec60e290cd134405a51920015b6d351d4e0b93b7b736d257f10725f74b5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ea362397e7d1522af10c0b917db1ecd13a46ac19c3632b769891638f83279442"
    sha256 cellar: :any,                 arm64_big_sur:  "afa1a9ba79e10bd063489131b2df9193cc6a089eb89c951119ca0aee4009f4d6"
    sha256 cellar: :any,                 monterey:       "dc7f86614e56c076a321ea5c8e56ea83b07f47fcaaaa0d12b9bbfa22913187a3"
    sha256 cellar: :any,                 big_sur:        "f1aac94bce8e39236a3f4d4fa7dbcae78af372bb5f8bd89be59ba9d3518a2899"
    sha256 cellar: :any,                 catalina:       "4624a6666519cf4d279dd684e07925a5c955fc8aafe527f86dc45d202ed80c80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43f46ec32d8201e78de7ab1ab889ba71d48e1296894dc3e305ad6e03e77413b"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end

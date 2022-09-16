class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.1.0/qpdf-11.1.0.tar.gz"
  sha256 "34a7cf3ac6e239510e9a20d7cbe10a4aff0f572c20e0a9bed0badb820a69e22d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2e6ee49528ec16b9b75803ca18d8b1c3f5fb04007a951c5ff26f199791aed0ba"
    sha256 cellar: :any,                 arm64_big_sur:  "c9df69b0d26c61cc6fe23ec8f31e541f2c22daa030bf66752af54b28efb2ef8d"
    sha256 cellar: :any,                 monterey:       "6249200d021e01a2e6ddf9ed17cabfe6f31eb105d97a6c4afda37342b1660c7f"
    sha256 cellar: :any,                 big_sur:        "b665d2dccb58f69fc0bf60acdaecfbf8e4e346ba796d143a8574e01688cc645b"
    sha256 cellar: :any,                 catalina:       "af97af23f5e4311ca937b1c5b5da867b7d8947ace7f082ad88ae726f9c984485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946de1ef971947ffba69831c2923a458228d6b716389efb79ff4106d64903233"
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

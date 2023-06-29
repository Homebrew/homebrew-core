class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.4.0/qpdf-11.4.0.tar.gz"
  sha256 "b0180971cc1b79b2dfe02ffe28e2c88c47f735888a3a2543dd42b9054ef146e1"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8d19d19e98e6e0fa6c9709ea2286848a3ee38dd04b52e097ffb1a865e312dab"
    sha256 cellar: :any,                 arm64_monterey: "54618fc7ec313298021cb325b0cc67bb1995ea61a6e7717065103806f648dd6a"
    sha256 cellar: :any,                 arm64_big_sur:  "8c32dc6031bec03d1738cc7e09449488afdfb57dfbf6d2ddde13b40517dd97fe"
    sha256 cellar: :any,                 ventura:        "8a33eddb8e8e877ddcfb7140fd864ef566143a13d5e116de61a2d3bb6ebf8ea1"
    sha256 cellar: :any,                 monterey:       "cd86906999318f280529e13d9844037815523fb598ca81f74ae0f860a480bfb2"
    sha256 cellar: :any,                 big_sur:        "5b44481f71e39351f36a63738668b9987bf95cf89a478de78edba5125a8954ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18f1ef55c780cd585c595e2da0acf7eb92559156158c817b5785252ed6b98e3d"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@3"

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

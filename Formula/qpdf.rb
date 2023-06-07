class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.4.0/qpdf-11.4.0.tar.gz"
  sha256 "b0180971cc1b79b2dfe02ffe28e2c88c47f735888a3a2543dd42b9054ef146e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34e2ceaaf019a3fb80a48aecdeab6b48ce435736977693550c39fb27c31c82e5"
    sha256 cellar: :any,                 arm64_monterey: "2a34387b75ccea96198d6f417a873090f63d785642ce6402302af6f13de14653"
    sha256 cellar: :any,                 arm64_big_sur:  "bea5263585bcf9b2d7fbd7e5a04ff6a54e73045483b7344436fc485862615da8"
    sha256 cellar: :any,                 ventura:        "37ff089f607aac1eda31027e8417e6cac44ceefe81f5799a137ac0f464a74ec9"
    sha256 cellar: :any,                 monterey:       "c8733c45d7fc671f026561d50a1f53ec503c81bc4a1d845faf2530fdd5b43649"
    sha256 cellar: :any,                 big_sur:        "caeeaf4915f477f4044e907cb87ba010acf6f790c5de94503eb394a5fc62f576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71c11a3741c026217c2afe06f1b1a5b3c90f954d9754b643ea7fbca0e7ca249c"
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

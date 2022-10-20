class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.1.1/qpdf-11.1.1.tar.gz"
  sha256 "25e8ec60e290cd134405a51920015b6d351d4e0b93b7b736d257f10725f74b5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c6ca588a9c2110504063f4f39a599d7917d7c5980c9bc41e8e20b62b0f864732"
    sha256 cellar: :any,                 arm64_big_sur:  "2b73d294fb3357a61e77c5200418f637373fdaaf19bc96661dc0884410468367"
    sha256 cellar: :any,                 monterey:       "8e661257b8ac6feae17826dd819febb13c825f18e843dd3deb5f9a9ce75c8133"
    sha256 cellar: :any,                 big_sur:        "a103cdd420778eb82285d1efdd2be23b9cae3e79b373eb5c7b75296bb2e0babe"
    sha256 cellar: :any,                 catalina:       "b6218ff894f992b544357550e994f8704e49a8da980bb2b36323b1aff5a9471e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "feb422895454de99f6acf9374df17c2dd9bfaf04ff95b89a45dcd363575e2922"
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

class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.3.1.tar.gz"
  sha256 "da89dafd8b6185aa635346753f9ddb29af29bc4abd92dd81f37d9d6560b5d64e"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f4bcaee48a934e59a22a29021a5dcaa857417651fcd9cd274c2476b5c6cbcc1f"
    sha256 cellar: :any,                 arm64_monterey: "883cf669ce25204e04a81c1df515ea02f848a7d907bd82fdbc394543d1375097"
    sha256 cellar: :any,                 arm64_big_sur:  "4b6849717fab3c4f870d3a619f202bf9fc1a90ad86c87a63c119aa88e79d8d8f"
    sha256 cellar: :any,                 ventura:        "7e27d4943fa7280709765beb41ff01272cf208e53a0c5405074df14dafd6170d"
    sha256 cellar: :any,                 monterey:       "55fd2c1dfdbc687e30ffe5d527030a4c8100e85d447b5094b2621e125668285b"
    sha256 cellar: :any,                 big_sur:        "97a1f11168ba2107003b5f9346289cf639cb5922c11d6995272e1ec45610d434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16aad2f1a7e9e78c05fc1b3c87435033cb854f3683e6be062096d2e27a9532bf"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end

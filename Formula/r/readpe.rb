class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://github.com/mentebinaria/readpe/archive/refs/tags/v0.85.1.tar.gz"
  sha256 "3218099d94c81488a4b042d86f64a4076835e1f2f2aff8ed4d58f01c20567507"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c4c0d71502a8cbcd7c90f1da7409e316bb15d84c2e003541bd63da2362451ebe"
    sha256 arm64_sequoia: "39059d97cdfec3a8b1bb7eca3a7acd3c0f1e8c4e1e322ec14db9bb38c15424ca"
    sha256 arm64_sonoma:  "d32bd36d656dc44a83bb6dfadf5ec738c4fe11804b804a916b1cb53400434a6c"
    sha256 arm64_ventura: "c5c6fb0c7ff57141804b2982fcb3f59611df7f3a85ce73c2b665b04f548ca633"
    sha256 sonoma:        "045c12282c8a90c85934c9f5ca06471ce865c64647c4be3a49606ae6ae09403a"
    sha256 ventura:       "73c192ae123766a4233942303830ab98f3c4c959ad62897a229f161fd77ea8db"
    sha256 arm64_linux:   "d493e303872e675b270d1c178913925c24de9124e9cabe0adc5d1b4bc845f918"
    sha256 x86_64_linux:  "50faef2834685643cdf64ddd6a6f3e87e3f70fdb7f813de2a0c88aaddb84a253"
  end

  depends_on "openssl@3"

  def install
    ENV.deparallelize
    inreplace "lib/libpe/Makefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource "homebrew-testfile" do
      url "https://the.earth.li/~sgtatham/putty/0.78/w64/putty.exe"
      sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
    end

    resource("homebrew-testfile").stage do
      assert_match(/Bytes in last page:\s+120/, shell_output("#{bin}/readpe ./putty.exe"))
    end
  end
end

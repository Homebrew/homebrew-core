class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/refs/tags/5.9.0.tar.gz"
  sha256 "f3280abd5ec70d58f9fd3853071670cfbb1e155d58e884aa43231f6ae10e0b59"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "f19ee8e2ee6513abe52a0e78fa121f5756e164c922ca04f494ca66aeb0e8337a"
    sha256 arm64_ventura:  "4e03fc09b70cf7ccfb60607dec6dafc96214c82c423713294b182c0fe7c81c3c"
    sha256 arm64_monterey: "f09b034fb19c393e0f097420ecf6ebf4ea7ab0a32a4c135250b0da805be939ca"
    sha256 sonoma:         "2551e974eb0a2316007f699d54d7c00868d274615eb07f125ec57954c2d85a6f"
    sha256 ventura:        "98c169cfaae28288fca7aad974c3463f9823d37cf6588d18ac6220c8972e6e7c"
    sha256 monterey:       "21f4aa4951d28c728da9c9bfddbf0716c6ecd69f5b6aa67cfd17535510d75625"
    sha256 x86_64_linux:   "56613297e8e3e173110f00c549215072a020698d468bcdabc9921ad8cc1ac34a"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -v")
  end
end

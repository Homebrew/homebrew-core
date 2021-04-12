class Radare2 < Formula
  desc "Reverse engineering framework"
  homepage "https://radare.org"
  url "https://github.com/radareorg/radare2/archive/5.2.0.tar.gz"
  sha256 "1ba06f16d14dfce38c3f8e687936b39400da4ca9e7bfb521169871302dd3baae"
  license "LGPL-3.0-only"
  head "https://github.com/radareorg/radare2.git"

  bottle do
    sha256 arm64_big_sur: "2164d2363e441386b36d49a6455f1fc3fb6fd808d18a9e30c6f5133ab2506e17"
    sha256 big_sur:       "cb71e445c259388b012c91ad4af4a72c9414a7e1e1b4efe62be0d9c88c62b0b3"
    sha256 catalina:      "ca7774db81bc1f44c699befad82e046deb82efdc7ef4362e66036b820e792b94"
    sha256 mojave:        "37b7618e90dc2289e69da94fc3e0836130a5eb6f009f26502d6aef614c1562d6"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "radare2 #{version}", shell_output("#{bin}/r2 -version")
  end
end

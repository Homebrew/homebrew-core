class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.4/rhash-1.4.4-src.tar.gz"
  sha256 "8e7d1a8ccac0143c8fe9b68ebac67d485df119ea17a613f4038cda52f84ef52a"
  license "0BSD"
  head "https://github.com/rhash/RHash.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "185980a787a26133954964d2453e7855beb3ed4bf3c55f9a594a3d456750fbb3"
    sha256 arm64_sonoma:   "ec69940028e8fcb9278ebba41f8f4eaf9c2fd551b361ebadb57b46724aaf92af"
    sha256 arm64_ventura:  "85e7a1577e11e64ede19b413af736fbc8cf54e2d1461906a6ff6b41fd709d694"
    sha256 arm64_monterey: "729cb8f7351431505bb7f57d4efbda5b7b3c97a11104c83af055fda35dd15b95"
    sha256 arm64_big_sur:  "be996648d541819d91a8978524f6725a251d72e9c98e5a0b3dd2243122b94a75"
    sha256 sonoma:         "515fa0b95cfdb4fab40f5303795ffc53fdefb7af4621722f12c4c8fd3965352a"
    sha256 ventura:        "8a8a0981aab3afa047c62bd5499e60dc19ed97346a2acd231c75e9b0d8ebfe25"
    sha256 monterey:       "436f258587befb5f28703d317afd598b12008304bd8fbdfc395519d1ccfc1e06"
    sha256 big_sur:        "7f6267a9424d92a40bd9a802fc725a384e55c0a518ac0dbb70f8ca3f72494761"
    sha256 x86_64_linux:   "44a16c670a13dfa5b0d7c2b387c808f3cc7f79fbc2af6e4e9db5b50ffc84e154"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-gettext"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"rhash", "-c", "test.sha1"
  end
end

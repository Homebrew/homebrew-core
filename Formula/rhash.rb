class Rhash < Formula
  desc "Utility for computing and verifying hash sums of files"
  homepage "https://sourceforge.net/projects/rhash/"
  url "https://downloads.sourceforge.net/project/rhash/rhash/1.4.1/rhash-1.4.1-src.tar.gz"
  sha256 "430c812733e69b78f07ce30a05db69563450e41e217ae618507a4ce2e144a297"
  license "0BSD"
  head "https://github.com/rhash/RHash.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "6f7648fc30e68060747fb9be6480be57c7b30680e429b619f34ead13b9cc80d6" => :big_sur
    sha256 "8eb637a12522739222253513a13aa3fafdc9ab586987f5648290349543017aca" => :arm64_big_sur
    sha256 "108986af36d715a05223344f3f338c04b0ce5aa6d6cf0c26776be015adaef36a" => :catalina
    sha256 "87ac3199498088f7d465dafefc6f014e10b4692ed3997895bbf1eb288dce8cdd" => :mojave
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    lib.install "librhash/#{shared_library("librhash")}"
    system "make", "-C", "librhash", "install-lib-headers"
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system "#{bin}/rhash", "-c", "test.sha1"
  end
end

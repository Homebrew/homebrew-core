class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.51.3.tar.gz"
  sha256 "2b0a90c3bf3a27574b0427cf4579dc2347b371bec3fea5739e1527edf74b2809"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?yaze-ag[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "dfde75b6e01c854c6e368e7c0b1e6ad1041595c7f7c3c4564aee651a3db1e239"
    sha256 arm64_monterey: "e16e79f90ea2bc48a220d2e4d3ce8e72acefe6a3f6382709d1d69b0cc4e0f221"
    sha256 arm64_big_sur:  "51ce224af28b3929a4b8563aa0cc740cbb43e7e2b5a31c6c0cfa502b52e200b3"
    sha256 ventura:        "ecf38a592bc940d4e02215feb31d7525600d86cbdc526c9830dcbb30ad64b9f4"
    sha256 monterey:       "0b4e934e85cea0db946cf6df95393be56e2e330665786fde9437e091197379d9"
    sha256 big_sur:        "32ef5add9479aef13177444a6a148e1fb2ae9719f2b043b1c235804b461f3e84"
    sha256 catalina:       "4954f1099ce8a6ed84a8f074221f4bd75a7abcc8e6303c733ff02221651f36bd"
    sha256 x86_64_linux:   "7a3cfeda8e67249ed33bdc5c6d37c037895967530f1f416cb8dbe908cfb922fe"
  end

  def install
    if OS.mac?
      inreplace "Makefile_solaris_gcc-x86_64", "md5sum -b", "md5"
      inreplace "Makefile_solaris_gcc-x86_64", /(LIBS\s+=\s+-lrt)/, '#\1'
    end

    bin.mkpath
    system "make", "-f", "Makefile_solaris_gcc-x86_64",
                   "BINDIR=#{bin}",
                   "MANDIR=#{man1}",
                   "LIBDIR=#{lib}/yaze",
                   "install"
  end

  test do
    (testpath/"cpm").mkpath
    assert_match "yazerc", shell_output("#{bin}/yaze -v", 1)
  end
end

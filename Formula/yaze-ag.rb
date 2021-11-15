class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "https://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.51.1.1.tar.gz"
  sha256 "0bcbb394b882bec91317c5fc08b7260a329b815b3fa4b50e669e1fc1ae49f5e4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?yaze-ag[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "9b9267faad5d115f3f6592eae2d51022bb835f5e9de633574252c97c234f457f"
    sha256 arm64_big_sur:  "a7f5f01645f28622f41c16ed912bedbe5c5f2f96a02ac4bb2cd69a79551a9ca8"
    sha256 monterey:       "da1faf22eaed1b98c8f3de08e1efbd1f9189451d3d6edec0470734b76e650383"
    sha256 big_sur:        "45cb642b939811dd73c7969ddb7d1f1cdddfcd6f334399b2e9469e39b1211819"
    sha256 catalina:       "fa198cfc1c08ae6d1297553ed40f858c26f5d75c945482778cca6da58eda60e0"
    sha256 mojave:         "66714634bcec98145e2ff2ba67563351c51e9a519fbda74a8e4dcd883ceb48b0"
    sha256 x86_64_linux:   "5d994911f70db7ddd38df5388b997c8926b8255fae82e888c07951c980792839"
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

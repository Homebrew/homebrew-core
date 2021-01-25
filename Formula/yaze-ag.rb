class YazeAg < Formula
  desc "Yet Another Z80 Emulator (by AG)"
  homepage "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/"
  url "http://www.mathematik.uni-ulm.de/users/ag/yaze-ag/devel/yaze-ag-2.40.5_with_keytrans.tar.gz"
  version "2.40.5"
  sha256 "d46c861eb0725b87dd5567062f277860b98d538fca477d8686f17b36ef39d9bd"
  license "GPL-2.0"

  bottle do
    sha256 "fa3420cfae542f27c772d484109f1a930fa82525c3349d7a4ea7bdbc8ad42649" => :big_sur
    sha256 "ee904628f8d8bdcafb50f18e4909d0d5a3cffe73f864ae66214fa91c8fabaa92" => :arm64_big_sur
    sha256 "f250f5ad984f31c1f96c744b81195c96bdccce6f74dd7548ceed19ba1172c117" => :catalina
    sha256 "86fb203ac02bad9477b7d3c7b78022df5feb126ae08df3ff93238d766f08a362" => :mojave
    sha256 "9f3e2a6e51423a97f03e99ed2bca0c7778fcf4f6b223332a824743bdbad20e09" => :high_sierra
    sha256 "daa83753710abc22b99dcdb20761673e9022e4205b5ddf225d7a6fdfdf47ed79" => :sierra
    sha256 "7df38aea48a13d73f0a040f1775d915b6bc543d7f7daafbb3eda0b77ee4fdbf6" => :el_capitan
  end

  def install
    inreplace "Makefile_solaris_gcc", "md5sum -b", "md5"
    bin.mkpath
    system "make", "-f", "Makefile_solaris_gcc",
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

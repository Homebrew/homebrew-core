class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https://www.scummvm.org/"
  url "https://www.scummvm.org/frs/scummvm-tools/2.0.0/scummvm-tools-2.0.0.tar.xz"
  sha256 "c2042ccdc6faaf745552bac2c00f213da382a7e382baa96343e508fced4451b3"
  head "https://github.com/scummvm/scummvm-tools.git"

  bottle do
    sha256 "84313eb5337d2f3c37f9ad5c494da4b43546422f9428f33dcf9b0c2af54473b8" => :high_sierra
    sha256 "5a9144ac0d1812d401ff76df988bac6bc681903bd94aad2b3f97a2e2279e9d73" => :sierra
    sha256 "c68cf67ed07a34a4db800598a64b6eb293ac714da6706ef89e58ce9a13ecde99" => :el_capitan
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxmac" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/scummvm-tools-cli", "--list"
  end
end

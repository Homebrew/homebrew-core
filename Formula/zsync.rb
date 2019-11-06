class Zsync < Formula
  desc "File transfer program"
  homepage "http://zsync.moria.org.uk/"
  url "http://zsync.moria.org.uk/download/zsync-0.6.2.tar.bz2"
  sha256 "0b9d53433387aa4f04634a6c63a5efa8203070f2298af72a705f9be3dda65af2"

  bottle do
    cellar :any_skip_relocation
    sha256 "333d4b2be5c1b6621bf7e7ac87199da1c5ec24a3cdb408c97ed733b6fafb89a1" => :catalina
    sha256 "9fa9f958c45a87c1a4e9b2ccdc95e732bb8ab248843ec3f0554e5b412d7f1ae5" => :mojave
    sha256 "b766bfc58f753376213e234d8e0e4238af1be39f77f239370583464040758fd6" => :high_sierra
    sha256 "8d6e7eade289c62689e752151021e7bccac7900a5e7217e8885f2c38aec42c2c" => :sierra
    sha256 "9bbe0e102ca6a2b7ca57af6b2b29984f7da59ce97d15ce550bbbb206f1ad1815" => :el_capitan
    sha256 "b7436466e25e1fe44e2169059d613d9df279a69c31183f6cacce953fc6a47e8b" => :yosemite
    sha256 "c44baf1fc7c83e88bb255307121de1546a0b89d43048e6c0f951648a649bc5fd" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "#{testpath}/foo"
    system "#{bin}/zsyncmake", "foo"
    sha1 = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    File.read("#{testpath}/foo.zsync") =~ /^SHA-1: #{sha1}$/
  end
end

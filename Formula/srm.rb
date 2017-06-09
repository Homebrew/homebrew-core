class Srm < Formula
  desc "Secure file deletion"
  homepage "http://srm.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/srm/1.2.15/srm-1.2.15.tar.gz"
  sha256 "7583c1120e911e292f22b4a1d949b32c23518038afd966d527dae87c61565283"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "src/srm"
    man1.install "doc/srm.1"
  end

  test do
    touch testpath/"test.txt"
    system bin/"srm", testpath/"test.txt"
    assert !(testpath/"test.txt").exist?
  end
end

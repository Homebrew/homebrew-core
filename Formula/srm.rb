class Srm < Formula
  desc "Secure replacement for rm(1)"
  homepage "https://srm.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/srm/1.2.15/srm-1.2.15.tar.gz"
  sha256 "7583c1120e911e292f22b4a1d949b32c23518038afd966d527dae87c61565283"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"hello_world.txt").write("Hello, world")
    system bin/"srm", testpath/"hello_world.txt"
  end
end

class TimeMachineCleanup < Formula
  desc "Clean up Time Machine backups and reduce its size"
  homepage "https://github.com/emcrisostomo/Time-Machine-Cleanup"
  url "https://github.com/emcrisostomo/Time-Machine-Cleanup/releases/download/2.0.0/tm-cleanup-2.0.0.tar.gz"
  sha256 "e2beac0ef924e1b12df453205767147ef54eb0518507558222df8688b8e8adc2"

  depends_on "dialog"

  def install
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tm-cleanup.sh", "-h"
  end
end

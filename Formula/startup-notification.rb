class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"

  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/startup-notification", "--version"
  end
end

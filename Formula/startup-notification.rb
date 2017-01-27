class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"

  bottle do
    cellar :any
    sha256 "1480bccd4d65d99905fdd5010bd156b0ff2ee2ada36ce0bcb4e7b74fa632c9da" => :sierra
    sha256 "7762bbbdb98d8f360e82a9ac5e94239f94433e7bb38e8eec309230270c5158e0" => :el_capitan
    sha256 "770f1ab8c0339c940b098d91989fbc06bacafabe1a91cc891e9891ef39e83781" => :yosemite
  end

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

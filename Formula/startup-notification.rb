class StartupNotification < Formula
  desc "Reference implementation of startup notification protocol"
  homepage "https://www.freedesktop.org/wiki/Software/startup-notification/"
  url "https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz"
  sha256 "3c391f7e930c583095045cd2d10eb73a64f085c7fde9d260f2652c7cb3cfbe4a"

  bottle do
    cellar :any
    sha256 "3febf31cc5b401f8023ef680288e684ffe12687c3b08eb14143704b081286c0a" => :catalina
    sha256 "9104d94776847d5605cae94d2206c44007fb5ef4d9db1071bdbcbcae0f9c0f84" => :mojave
    sha256 "593deddd4f3398736ba818eaa224dcc5b5337c88ba13c7ff1676f96b5c3adfd2" => :high_sierra
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
end

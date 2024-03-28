class Worker < Formula
  desc "Two-pane file manager for the X Window System"
  homepage "http://www.boomerangsworld.de/cms/worker/index.html"
  url "http://www.boomerangsworld.de/cms/worker/downloads/worker-5.0.1.tar.bz2"
  sha256 "dccb4a356be9ed86918bc942f8dfc08ab6a0a710b290c7e912df1d5e01e94ebc"
  license "GPL-2.0-or-later"

  depends_on "dbus"
  depends_on "libmagic"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxinerama"
  depends_on "lua"
  depends_on "openssl@3"

  on_linux do
    depends_on "avfs"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system "#{bin}/worker", "-V"
  end
end

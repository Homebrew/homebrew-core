class Wavemon < Formula
  desc "Ncurses-based monitoring application for wireless network devices on Linux"
  homepage "https://github.com/uoaerg/wavemon"
  url "https://github.com/uoaerg/wavemon/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "768d7c580fcc592efcacac924dcfd2ebe131608f5c8ac67d36e35731e1ac683a"
  license all_of: ["GPL-3.0-or-later", "ISC"]

  depends_on "autoconf" => :build
  depends_on "pkgconf" => :build
  depends_on "libnl"
  depends_on :linux
  depends_on "ncurses"

  allow_network_access! :test
  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install-suid-root"
  end

  test do
    assert_match "input is not from a terminal", shell_output("#{bin}/wavemon -g 2>&1", 1)
  end
end

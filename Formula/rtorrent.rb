class Rtorrent < Formula
  desc "Ncurses BitTorrent client based on libtorrent-rakshasa"
  homepage "https://github.com/rakshasa/rtorrent"
  url "https://github.com/rakshasa/rtorrent/releases/download/v0.9.8/rtorrent-0.9.8.tar.gz"
  sha256 "9edf0304bf142215d3bc85a0771446b6a72d0ad8218efbe184b41e4c9c7542af"

  bottle do
    cellar :any
    sha256 "2040210e9850a74760c06cd96dab5e7dfbec58187e768127e657216f51f30e87" => :catalina
    sha256 "1e9e0d6926724f70776d19c39377c422e17cfa61729043853b48159e2df779c0" => :mojave
    sha256 "079eb5eee6d8844045cf37f88f153d0be37731caa53768a50799acbd13a2ef6b" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libtorrent-rakshasa"
  depends_on "xmlrpc-c"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    args = ["--prefix=#{prefix}", "--with-xmlrpc-c",
            "--disable-debug", "--disable-dependency-tracking"]

    system "sh", "autogen.sh"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    pid = fork do
      exec "#{bin}/rtorrent", "-n", "-s", testpath
    end
    sleep 3
    assert_predicate testpath/"rtorrent.lock", :exist?
  ensure
    Process.kill("HUP", pid)
  end
end

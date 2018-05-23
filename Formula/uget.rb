class Uget < Formula
  desc "Open Source Download Manager app"
  homepage "http://ugetdm.com/"
  url "https://downloads.sourceforge.net/projects/urlget/files/uget%20%28stable%29/2.2.1/uget-2.2.1.tar.gz"
  sha256 "445cf58799a9a06e08cd4180b172f4b0a8a8c2ee82da732bdfe2dd502d949936"
  depends_on "gettext"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "intltool"
  depends_on "libnotify"
  depends_on "pkg-config"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"uget-gtk", "-V"
  end
end

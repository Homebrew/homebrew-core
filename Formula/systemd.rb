class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "http://www.freedesktop.org/software/systemd/systemd-221.tar.xz"
  sha256 "085e088650afbfc688ccb13459aedb1fbc7c8810358605b076301f472d51cc4f"
  # tag "linuxbrew"

  bottle do
    sha256 "b24ff69678f718005768a023d1c264c2486cc69027be407107341c5f648d0fcd" => :x86_64_linux
  end

  depends_on "homebrew/dupes/gperf" => :build
  depends_on "homebrew/dupes/m4" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libcap"
  depends_on "pkg-config" => :build
  depends_on "util-linux" # for libmount
  depends_on "coreutils" => :build
  depends_on "XML::Parser" => :perl

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--with-rootprefix=#{prefix}",
      "--with-sysvinit-path=#{etc}/init.d",
      "--with-sysvrcnd-path=#{etc}/rc.d"
    system "make", "install"
  end

  test do
    system "#{bin}/systemd-path"
  end
end

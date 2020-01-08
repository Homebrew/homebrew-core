class Urlview < Formula
  desc "URL extractor/launcher"
  homepage "https://packages.debian.org/sid/misc/urlview"
  url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9.orig.tar.gz"
  version "0.9-20"
  sha256 "746ff540ccf601645f500ee7743f443caf987d6380e61e5249fc15f7a455ed42"

  bottle do
    cellar :any_skip_relocation
    sha256 "362aa6e91200cf83cd7de1150d2081f03cd9cb2adb9fccdcd53a5308fc20016f" => :catalina
    sha256 "82e4e63f3439db87bc1f1f4b51d9ff7298a69c610e726a56b5ede58463975b59" => :mojave
    sha256 "ded9ca6285a2c87ecfe9af130e5bc231adfa501c2aae5602c13f40b998077f6a" => :high_sierra
    sha256 "0f75c9a2a4018f9bac7262314a9f391c63353abd707f820b92a389b21bbf08b8" => :sierra
    sha256 "f748da269d23717c525cc0272bf90a1c286a16aaa868d9433505f6a72d28bfed" => :el_capitan
  end

  patch do
    url "https://deb.debian.org/debian/pool/main/u/urlview/urlview_0.9-20.diff.gz"
    sha256 "0707956fd7195aefe6d6ff2eaabe8946e3d18821a1ce97c0f48d0f8d6e37514e"
  end

  def install
    inreplace "urlview.man", "/etc/urlview/url_handler.sh", "open"
    inreplace "urlview.c",
      '#define DEFAULT_COMMAND "/etc/urlview/url_handler.sh %s"',
      '#define DEFAULT_COMMAND "open %s"'

    man1.mkpath
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end
end

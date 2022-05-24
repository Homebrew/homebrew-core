class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.8.tar.gz"
  sha256 "7a87a6fe7b1bd36a1ce277cf50e125ece7b2ed0236e252a66e2b34ca8f88b7f5"
  license "ISC"

  bottle do
    sha256 arm64_monterey: "a163c6fb57235560fc3e117b0a0ae65cfb5a88f0a4c919243f7b7367b36bc5d7"
    sha256 arm64_big_sur:  "f541f00593f51cb535132b0cfaf429a0cd86955d508d71ce5dd61391947e61eb"
    sha256 monterey:       "c96bbcfa6a3b610548bef1691e55a7f5d1d9015e071cadb079f0728ac9ff24eb"
    sha256 big_sur:        "d09526b985cd5eb82d5fd28f2b45cae6b3e586e691f712760ad228377ccb9a46"
    sha256 catalina:       "e68a160486ad4a292ed1087722c9612b785f3a307213851814f06abe571cb348"
  end

  depends_on "pkg-config" => :build
  depends_on "libressl"
  depends_on :macos

  def install
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "parse file ta/", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1").lines.last
  end
end

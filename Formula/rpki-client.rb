class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.6.tar.gz"
  sha256 "d147bbedd1eea0fac3a431144f836074588949c67e7ef6fdd94ecec37b762b6b"
  license "ISC"

  bottle do
    sha256 arm64_monterey: "802bf2381ed7d568056c986c016517c63072bb33023864ab44e76c07c7d4f4c6"
    sha256 arm64_big_sur:  "26dc818750a48fbf57983e5ee3148d68e27dc1cbd65d12d892c1fe58333e82e4"
    sha256 monterey:       "8ad7e8b713feed8d58c76c1cf6541f65cf0fdd9d2658afb4fd4dfd3416432c97"
    sha256 big_sur:        "6a17e768be73e1f18fe8b84a8ac7fd65afc6871d5b9c8ae594b355b9f67dcf54"
    sha256 catalina:       "72c502d598e996027bb4efe7bea0d26dd855fbc8783658d0667de01c56274aa6"
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
    assert_match "parse file ta:", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1").lines.last
  end
end

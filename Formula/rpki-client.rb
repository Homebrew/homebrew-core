class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/index.html"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-7.6.tar.gz"
  sha256 "d147bbedd1eea0fac3a431144f836074588949c67e7ef6fdd94ecec37b762b6b"
  license "ISC"

  bottle do
    sha256 arm64_monterey: "d2c1e200ed3fed78bcdec733dc0e644c595b95b427281a994dc6e3ecc36e46bf"
    sha256 arm64_big_sur:  "56eaa8f7fbb7c9d673862d788c2c3af153d4491ab839398af8e40325e70eee0f"
    sha256 monterey:       "a18fb56a1c25775c161c23164fee57020d6e2067e9598e3bb2dac2bd6efd021e"
    sha256 big_sur:        "eab8f4c81d172ccad44b10402a45d03e4edbb87b49e49d4725afab4450f2dec6"
    sha256 catalina:       "3f3bb03603511673944161dc8bd105f43ecf22c7dbc87bc0ac5848dbdb9fce85"
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

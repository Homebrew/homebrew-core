class Urler < Formula
  desc "Command-line tool for URL parsing and manipulation"
  homepage "https://github.com/curl/urler"
  url "https://github.com/curl/urler/archive/64a48c004cbc0e91d15aff2e090f423ab7555b6c.tar.gz"
  version "0.1"
  sha256 "730d4d2611d1844a0389b71a214bd8b0b1c86724f65ec913d777af482a7db496"
  license "curl"

  def install
    system "make"
    system "make", "BINDIR=#{bin}", "MANDIR=#{man}", "install"
  end

  test do
    test_url = "https://example.com/"
    shell_output_url = shell_output("#{bin}/urler --url https://curl.se --set-host example.com").strip

    assert_equal test_url, shell_output_url
  end
end

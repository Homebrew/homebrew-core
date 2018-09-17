class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 1
  head "https://github.com/vysheng/tg.git"

  bottle do
    sha256 "850f77c9390643abf874aac99b624e312b2ceca803fd21207df48a5c9230fe66" => :mojave
    sha256 "938c36ae945666dc88be1aec3e714a79a71d42f9daa1010d0e73206b61f9a635" => :high_sierra
    sha256 "e9ff00dd7a4983b41b08519f0a756990a0aa30bc2263b6e262f72ee3e9b23ce2" => :sierra
    sha256 "caabf1d19eb2b5b04560e9dc15583eb7dc3c0b0a733c732d73da09abf51dbbaf" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libconfig"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "readline"

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  patch do
    url "https://github.com/vysheng/tg/pull/1306.patch?full_index=1"
    sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
      --disable-liblua
      --disable-python
    ]

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli" => "telegram"
    (etc/"telegram-cli").install "server.pub"
  end

  test do
    assert_match "telegram-cli", (shell_output "#{bin}/telegram -h", 1)
  end
end

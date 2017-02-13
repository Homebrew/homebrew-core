class TelegramCli < Formula
  desc "Command-line interface for Telegram."
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  head "https://github.com/vysheng/tg.git"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libevent"
  depends_on "openssl"
  depends_on "libconfig"
  depends_on "jansson"
  depends_on "lua" => :optional
  depends_on "python" => :optional

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  patch do
    url "https://github.com/vysheng/tg/pull/1306.patch"
    sha256 "97c692d332f3078144f514e2bebe08c3be187a0d4a2ab4bf240479f1a0f6c740"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
    ]

    args << "--disable-liblua" if build.without? "lua"
    args << "--disable-python" if build.without? "python"

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli" => "telegram"
    (etc/"telegram-cli").install "server.pub"
  end

  test do
    assert_match "telegram-cli", (shell_output "#{bin}/telegram -h", 1)
  end
end

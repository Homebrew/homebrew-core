class TelegramCli < Formula
  desc "Command-line interface for Telegram."
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  head "https://github.com/vysheng/tg.git"

  bottle do
    sha256 "e3d11d044d22c704c4cce49b3e02c1016361c0ca0416cb9c97648c7b6972c6da" => :sierra
    sha256 "899040eda68f601bcdfbf317159f885d6f6adc59b4c58ce4e1e9d72f7943dc7e" => :el_capitan
    sha256 "55487d971dec4cbfc5944ba94c691ade8a814de805ea451dea1c5884f2e28925" => :yosemite
  end

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
    url "https://github.com/vysheng/tg/pull/1306.patch?full_index=1"
    sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
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

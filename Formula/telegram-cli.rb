class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag      => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 3
  head "https://github.com/vysheng/tg.git"

  bottle do
    sha256 "81be8a68355b7b07dd127cca1931571d8a6f3edc1933ad3d79a0d1b7f535eb12" => :mojave
    sha256 "fc81065c039976aff803542298a166059dff35383513128a12d7fe26d3d11977" => :high_sierra
    sha256 "37ff2799609915d3746a9482aeb332968170617b3e693693ef832b6bad2a00d5" => :sierra
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

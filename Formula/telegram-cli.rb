class TelegramCli < Formula
  desc "Command-line interface for Telegram"
  homepage "https://github.com/vysheng/tg"
  url "https://github.com/vysheng/tg.git",
      :tag      => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 4
  head "https://github.com/vysheng/tg.git"

  bottle do
    rebuild 1
    sha256 "4c1a9d233c3b46d75badb6e89e007ff9763e55071474ce11d0e109e7ee24aefe" => :catalina
    sha256 "da9d09f1f4a317ed14c97e67fc2def18c4cd728a7023ab80424a8d548437ee74" => :mojave
    sha256 "410b56cc04620c7a1f495b500b41fa61339cc68444c1c65939bb4fb0c4cc96ef" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jansson"
  depends_on "libconfig"
  depends_on "libevent"
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  # Look for the configuration file under /usr/local/etc rather than /etc on OS X.
  # Pull Request: https://github.com/vysheng/tg/pull/1306
  patch do
    url "https://github.com/vysheng/tg/pull/1306.patch?full_index=1"
    sha256 "1cdaa1f3e1f7fd722681ea4e02ff31a538897ed9d704c61f28c819a52ed0f592"
  end

  # Patch for OpenSSL 1.1 compatibility
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/129507e4ee3dc314156e179902ac375abd00c7fa/telegram-cli/openssl-1.1.diff"
    sha256 "eb6243e1861c0b1595e8bdee705d1acdd2678e854f0919699d4b26c159e30b5e"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
      --disable-liblua
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

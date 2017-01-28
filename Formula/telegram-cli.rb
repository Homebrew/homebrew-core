class TelegramCli < Formula
  desc "Command-line interface for Telegram."
  homepage "https://github.com/vysheng/tg"
  # Use the tag instead of the tarball to get submodules
  url "https://github.com/vysheng/tg.git",
      :tag => "1.3.1",
      :revision => "5935c97ed05b90015418b5208b7beeca15a6043c"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "readline" => :build
  depends_on "libevent" => :build
  depends_on "openssl" => :build
  depends_on "libconfig" => :recommended
  depends_on "jansson" => :recommended
  depends_on "lua" => :recommended
  depends_on "python" => :recommended

  def install
    args = %W[
      --prefix=#{prefix}
      CFLAGS=-I#{Formula["readline"].include}
      CPPFLAGS=-I#{Formula["readline"].include}
      LDFLAGS=-L#{Formula["readline"].lib}
    ]

    args << "--disable-libconfig" if build.without? "libconfig"
    args << "--disable-json" if build.without? "jansson"
    args << "--disable-liblua" if build.without? "lua"
    args << "--disable-python" if build.without? "python"

    system "./configure", *args
    system "make"

    bin.install "bin/telegram-cli"
  end
end

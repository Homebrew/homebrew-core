class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.6.tar.xz"
  sha256 "fa9e3130e7afdfb6eff1b7892caac3efdd38a442f9989ca8c061eced2c755148"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "ec8471d8c1fc1cc650768fe3d4d4412eabadd2f69612a88ce4e7f25f86242c92" => :mojave
    sha256 "8ca849a749fc64fc7369d39787d070294ad5031da6aeeaa81586552fd87e2738" => :high_sierra
    sha256 "70f5586b3a6b96f1aba08c83772391d2fa6ffc723cff5a81965fe27faa003e9d" => :sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "perl"
  depends_on "python"
  depends_on "ruby" if MacOS.version <= :sierra

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
    ]

    if MacOS.version >= :sierra
      args << "-DRUBY_EXECUTABLE=/usr/bin/ruby"
      args << "-DRUBY_LIB=/usr/lib/libruby.dylib"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end

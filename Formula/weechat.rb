class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.5.tar.xz"
  sha256 "52c87775c3ff9714a62cfa5b7e13e2fa59bf32829fe083781c1d9c7f1c2d4c27"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "ea68e23e98b564aea6b709f5f603654e0ac49a88478188862f9c404495b2dd89" => :mojave
    sha256 "30f05d569a9ee7e3d4669b2c9963227d2d8d699458d75a45d958f0144eaa1ad0" => :high_sierra
    sha256 "f1e0507ef73e304543e62344b6590f03520f94b3a9eb9faf946471717a17a09f" => :sierra
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
  depends_on "python@2"
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

class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.5.tar.xz"
  sha256 "52c87775c3ff9714a62cfa5b7e13e2fa59bf32829fe083781c1d9c7f1c2d4c27"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "dfb5a3f45ac3055766b966c82c0dcd0f8dc5352f517407c66ba48070ffff0a89" => :mojave
    sha256 "e3405b2ce24bca258f8772ebc9eb16098d3d8f289c3e12f8111b7b9c2bf12d5c" => :high_sierra
    sha256 "ba3cc256a23111edb399b374b2ec828f177db1ca1c4fdf6c4e2151f9a1ca87db" => :sierra
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

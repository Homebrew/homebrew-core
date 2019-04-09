class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.4.tar.xz"
  sha256 "86d626c58d666ca58ef4762ff60c24c89f4632d95ed401773d5584043d865c73"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "17f0b92a8889d6716b8e568cb03cbf1df17eac761f42333b912bbb9dfca08291" => :mojave
    sha256 "feea73ff988119f26b99ccec16307d0da2a0a66ef18d7d1135c457d98a63c119" => :high_sierra
    sha256 "915e1455d6e6f20e1d8a5b32fe7f28651189a389131a229d94050bd5b6c2e7b5" => :sierra
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

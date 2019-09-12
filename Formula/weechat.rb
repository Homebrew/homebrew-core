class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.6.tar.xz"
  sha256 "fa9e3130e7afdfb6eff1b7892caac3efdd38a442f9989ca8c061eced2c755148"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "b394f94725481ffb20c88325947f66da4e8d8e3106d3b41c49431915fc297aa0" => :mojave
    sha256 "1cd660bf3084ddbbe4c1fcebd38f484265e13072d153ad895dd4498d652b3953" => :high_sierra
    sha256 "769a4ce55cee49db0fcf430201d4a94b077adeeb83901f231e2481c9034a9749" => :sierra
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

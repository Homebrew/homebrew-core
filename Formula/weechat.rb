class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.3.tar.xz"
  sha256 "ef8654313bfb0ca92e27cf579efb2d9b17e53505e615bf3d71a51aef44e56a5f"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    rebuild 1
    sha256 "ee048586abb72f35c7f091e205d4a09039ef886671e098dc7f9d0cdd7261327f" => :mojave
    sha256 "11024e9ad3f7bb9e5c544d6c9a3d1fe4d57993ac919ee6cc0bf8dc522bb2d53b" => :high_sierra
    sha256 "bfc4321d59755a47b281c288ac5f290593839144a0471c835aa48c72c6fb3334" => :sierra
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "aspell"
  depends_on "curl"
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

class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.3.tar.xz"
  sha256 "ef8654313bfb0ca92e27cf579efb2d9b17e53505e615bf3d71a51aef44e56a5f"
  revision 1
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "bd6340bac1555785aeff6584ab61d104402297b78a67d424517c4e6c613074d8" => :mojave
    sha256 "e97739b3e529fce08adb86b86cc4b2c660528ee9b2929ba783ab2ecf4b7acf42" => :high_sierra
    sha256 "630b354c0f7dc8c814a3d1d7c5c369c61f8111763e339d878ce5ebf0a2b7ad40" => :sierra
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

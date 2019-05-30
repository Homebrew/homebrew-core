class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.4.tar.xz"
  sha256 "86d626c58d666ca58ef4762ff60c24c89f4632d95ed401773d5584043d865c73"
  revision 2
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "c0616c0a1882bbfe865332248a82278ad48d489327dd5cf0fafc50c178a24e24" => :mojave
    sha256 "0d876e4a5484ba35f22bb689ad4a6d0a066c0ef7e7bb86dd4b072a3ca0261c7a" => :high_sierra
    sha256 "5d5f73a9c0367663cde942c2938a4bc56a703cf1897b57df71734b1a323368d7" => :sierra
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

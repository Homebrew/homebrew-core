class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-2.2.tar.xz"
  sha256 "48cf555fae00d6ce876d08bb802707b657a1134808762630837617392899a12f"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "dbcf559ef0e456d692aa89131f29c24246a203ea6fc2ad97cb57238e222071fe" => :mojave
    sha256 "0dd89c3cb155ddd24fd088b678a54a1db651959c27c1ea0de46fe7e0003d52fd" => :high_sierra
    sha256 "668533dfc9307c64260a154a06ad3e0245b7033b6ca2d36a6c291394c1f721e1" => :sierra
    sha256 "3b3c0b275171c06a0aa3f29b3a239f2f7a30cf70e88839a489fba5892253b8fb" => :el_capitan
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-curl", "Build with brewed curl"

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "aspell" => :optional
  depends_on "curl" => :optional
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "python@2" => :optional
  depends_on "ruby" => :optional if MacOS.version <= :sierra

  def install
    args = std_cmake_args + %W[
      -DENABLE_MAN=ON
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
    ]

    if build.without? "ruby"
      args << "-DENABLE_RUBY=OFF"
    elsif build.with?("ruby") && MacOS.version >= :sierra
      args << "-DRUBY_EXECUTABLE=/usr/bin/ruby"
      args << "-DRUBY_LIB=/usr/lib/libruby.dylib"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python@2"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  def caveats
    <<~EOS
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end

  test do
    system "#{bin}/weechat", "-r", "/quit"
  end
end

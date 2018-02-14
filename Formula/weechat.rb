class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  head "https://github.com/weechat/weechat.git"

  stable do
    url "https://weechat.org/files/src/weechat-2.0.1.tar.xz"
    sha256 "6943582eabbd8a6fb6dca860a86f896492cae5fceacaa396dbc9eeaa722305d1"

    # Recognise Ruby 2.5.x as valid.
    patch do
      url "https://github.com/weechat/weechat/commit/cb98f528.patch?full_index=1"
      sha256 "e9700e24606447edfbd5de15b4d9dc822454a38ed85f678b15f84b4db2323066"
    end
  end

  bottle do
    sha256 "86f9c7062cd5f4ca6625b175144ec37b55f462a9463a3f9852d74f56b404302b" => :high_sierra
    sha256 "1655ae54d7be8e9617c7d65d7ccc3f25e3ea1cd93d301b3ccb2d4fd056029db7" => :sierra
    sha256 "e8070f500a5f922b3f862ea67104ee9e8c7dd0f929caf408700c664ef07bfb7a" => :el_capitan
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-curl", "Build with brewed curl"
  option "with-debug", "Build with debug information"
  option "without-tcl", "Do not build the tcl module"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "gettext"
  depends_on "aspell" => :optional
  depends_on "lua" => :optional
  depends_on "perl" => :optional
  depends_on "python" => :optional
  depends_on "ruby" => :optional if MacOS.version <= :sierra
  depends_on "curl" => :optional

  def install
    args = std_cmake_args + %W[
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
    ]
    if build.with? "debug"
      args -= %w[-DCMAKE_BUILD_TYPE=Release]
      args << "-DCMAKE_BUILD_TYPE=Debug"
    end

    if build.without? "ruby"
      args << "-DENABLE_RUBY=OFF"
    elsif build.with?("ruby") && MacOS.version >= :sierra
      args << "-DRUBY_EXECUTABLE=/usr/bin/ruby"
      args << "-DRUBY_LIB=/usr/lib/libruby.dylib"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_TCL=OFF" if build.without? "tcl"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"

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

class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.6.tar.gz"
  sha256 "3061e57460e0e3e4533551c45ced53b222fe0933848250d0fb7337d9aacfd853"

  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "969b36c1535667895dc0db113177cc7a851b731cebf5c754e5bd19c3bae32339" => :sierra
    sha256 "86118fb13bbbe371612fe38351adbf5b32da676daf139e59f7a0f9e1a2ae5290" => :el_capitan
    sha256 "80ac11ead01b4e87a5006f0663cb1efe6e500d2c7d05b66610d5f27cbe97f5e1" => :yosemite
    sha256 "5829823f5b1e1605a10f372b903467d80bc39377f686316bd7284c2cb94ed098" => :mavericks
  end

  option "with-perl", "Build the perl module"
  option "with-ruby", "Build the ruby module"
  option "with-tcl", "Build the tcl module"
  option "with-curl", "Build with brewed curl"
  option "with-debug", "Build with debug information"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "gettext"
  depends_on "guile" => :optional
  depends_on "aspell" => :optional
  depends_on "lua" => :optional
  depends_on :python => :optional
  depends_on "curl" => :optional

  def install
    args = std_cmake_args
    if build.with? "debug"
      args -= %w[-DCMAKE_BUILD_TYPE=Release]
      args << "-DCMAKE_BUILD_TYPE=Debug"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_RUBY=OFF" if build.without? "ruby"
    args << "-DENABLE_TCL=OFF" if build.without? "tcl"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_GUILE=OFF" if build.without? "guile"
    args << "-DENABLE_PYTHON=OFF" if build.without? "python"
    args << "-DENABLE_JAVASCRIPT=OFF"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install", "VERBOSE=1"
    end
  end

  def caveats; <<-EOS.undent
      Weechat can depend on Aspell if you choose the --with-aspell option, but
      Aspell should be installed manually before installing Weechat so that
      you can choose the dictionaries you want.  If Aspell was installed
      automatically as part of weechat, there won't be any dictionaries.
    EOS
  end

  test do
    system "weechat", "-r", "/quit"
  end
end

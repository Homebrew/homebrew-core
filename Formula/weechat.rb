class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.8.tar.xz"
  sha256 "b65fc54e965399e31a30448b5f6c8067fcd6ad369e9908ff7c1fd45669c5e017"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "4840fc43ba1155600c06e56b31cdeea052654e34b727eb03a145c1fe6ba63aa0" => :sierra
    sha256 "a158ebbbff7c97410593449ecd30079afd3a46fd05ae973689c0da4447bf8e08" => :el_capitan
    sha256 "fc7048e92dd1b4ff62190fecc960d87567e3ba5c46884efbdc080f3de4cebf62" => :yosemite
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
  depends_on :python => :optional
  depends_on :ruby => ["2.1", :optional]
  depends_on :perl => ["5.3", :optional]
  depends_on "curl" => :optional

  def install
    args = std_cmake_args << "-DENABLE_GUILE=OFF"
    if build.with? "debug"
      args -= %w[-DCMAKE_BUILD_TYPE=Release]
      args << "-DCMAKE_BUILD_TYPE=Debug"
    end

    args << "-DENABLE_LUA=OFF" if build.without? "lua"
    args << "-DENABLE_PERL=OFF" if build.without? "perl"
    args << "-DENABLE_RUBY=OFF" if build.without? "ruby"
    args << "-DENABLE_ASPELL=OFF" if build.without? "aspell"
    args << "-DENABLE_TCL=OFF" if build.without? "tcl"
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
    system "#{bin}/weechat", "-r", "/quit"
  end
end

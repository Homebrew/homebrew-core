class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  url "https://weechat.org/files/src/weechat-1.9.tar.xz"
  sha256 "cc85eb299a5a979bcfda390c20bcb9dd8fd7b25a32fb01e5f128e13c51fa7dff"
  head "https://github.com/weechat/weechat.git"

  bottle do
    sha256 "8f3e316f89797ecf3626453dd761d2e360c3ddfd3512358760f48020ef016911" => :sierra
    sha256 "402cb6ba36f690673636df012e6530b3742f87637641780f49519ef1568f5c39" => :el_capitan
    sha256 "8629922ac45893e9c4beec5af6642ec8db295a314021e7ad6756646298a5585e" => :yosemite
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
    args = std_cmake_args + %W[
      -DENABLE_GUILE=OFF
      -DCA_FILE=#{etc}/openssl/cert.pem
      -DENABLE_JAVASCRIPT=OFF
    ]
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

class Weechat < Formula
  desc "Extensible IRC client"
  homepage "https://www.weechat.org"
  head "https://github.com/weechat/weechat.git"

  stable do
    url "https://weechat.org/files/src/weechat-1.6.tar.xz"
    sha256 "d667db4f98307a47c9bfbbe00a4be44c356b8483d566740618b484d8565a16e3"

    # All these patches are already upstream. Remove on 1.7 release.
    # This top patch is unrelated to the build fix, but other two
    # patches fail to apply cleanly without it.
    patch do
      url "https://github.com/weechat/weechat/commit/2122cbf9.patch"
      sha256 "8d48b9abf04c717109bc29bcdc47420f2e21ff545fb5af85162dd9722fcab48c"
    end

    # These two patches fix lresolv linking errors.
    # https://github.com/Homebrew/homebrew-core/pull/4427
    patch do
      url "https://github.com/weechat/weechat/commit/e098a0d.patch"
      sha256 "e459496133b981d9121ae82977e8a8709d82d63a019963f704fb35fb8a36312b"
    end

    patch do
      url "https://github.com/weechat/weechat/commit/c9fbb91.patch"
      sha256 "bb3ea7bbb4e4fcf20cef7d89ce38dd4c73b90f3482e3af248c0e93c2831cd854"
    end
  end

  bottle do
    sha256 "40bdea0f0c9d0f79a81971bdfe4e1482d7f455c74b9cd2a14c13b34525be08b9" => :sierra
    sha256 "04ad4707f713e3bf5a8e14d5e3de7f57f2fabeac3cc307fa642b12b53a28b44b" => :el_capitan
    sha256 "78d808d561c8689dd9cdacff87630b1bcd3e9f991f8249f72add6be614221abd" => :yosemite
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

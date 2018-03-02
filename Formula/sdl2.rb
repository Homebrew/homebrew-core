class Sdl2 < Formula
  desc "Low-level access to audio, keyboard, mouse, joystick, and graphics"
  homepage "https://www.libsdl.org/"
  url "https://libsdl.org/release/SDL2-2.0.8.tar.gz"
  sha256 "edc77c57308661d576e843344d8638e025a7818bff73f8fbfab09c3c5fd092ec"

  bottle do
    cellar :any
    sha256 "d3436a34a1795c14dd71616ea222b06f47b82d46818fb845b630431f3f036de6" => :high_sierra
    sha256 "8e0ed1c42064a78da85f0375fa32e36e2f6e94d33fa1acbf67b7b2777691aeed" => :sierra
    sha256 "44aa4e28bac52c21e3d1751394d1927768817a6af3cedd8c54e23ae09e52cff3" => :el_capitan
  end

  head do
    url "https://hg.libsdl.org/SDL", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Compile and install the tests"

  # https://github.com/mistydemeo/tigerbrew/issues/361
  if MacOS.version <= :snow_leopard
    patch do
      url "https://gist.githubusercontent.com/miniupnp/26d6e967570e5729a757/raw/1a86f3cdfadbd9b74172716abd26114d9cb115d5/SDL2-2.0.3_OSX_104.patch"
      sha256 "4d01f05f02568e565978308e42e98b4da2b62b1451f71c29d24e11202498837e"
    end
  end

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head? || build.devel?

    args = %W[--prefix=#{prefix}]

    # LLVM-based compilers choke on the assembly code packaged with SDL.
    if ENV.compiler == :clang && DevelopmentTools.clang_build_version < 421
      args << "--disable-assembly"
    end
    args << "--without-x"
    args << "--disable-haptic" << "--disable-joystick" if MacOS.version <= :snow_leopard

    system "./configure", *args
    system "make", "install"

    if build.with? "test"
      ENV.prepend_path "PATH", bin
      # We need the build to point at the newly-built (not yet linked) copy of SDL.
      inreplace bin/"sdl2-config", "prefix=#{HOMEBREW_PREFIX}", "prefix=#{prefix}"
      cd "test" do
        # These test source files produce binaries which by default will reference
        # some sample resources in the working directory.
        # Let's point them to the test_extras directory we're about to set up instead!
        inreplace %w[controllermap.c loopwave.c loopwavequeue.c testmultiaudio.c
                     testoverlay2.c testsprite2.c],
                  /"(\w+\.(?:bmp|dat|wav))"/,
                  "\"#{pkgshare}/test_extras/\\1\""
        system "./configure", "--without-x"
        system "make"
        # Tests don't have a "make install" target
        (pkgshare/"tests").install %w[checkkeys controllermap loopwave loopwavequeue testaudioinfo
                                      testerror testfile testgl2 testiconv testjoystick testkeys
                                      testloadso testlock testmultiaudio testoverlay2 testplatform
                                      testsem testshape testsprite2 testthread testtimer testver
                                      testwm2 torturethread]
        (pkgshare/"test_extras").install %w[axis.bmp button.bmp controllermap.bmp icon.bmp moose.dat
                                            picture.xbm sample.bmp sample.wav shapes]
        bin.write_exec_script Dir["#{pkgshare}/tests/*"]
      end
      # Point sdl-config back at the normal prefix once we've built everything.
      inreplace bin/"sdl2-config", "prefix=#{prefix}", "prefix=#{HOMEBREW_PREFIX}"
    end
  end

  test do
    system bin/"sdl2-config", "--version"
  end
end

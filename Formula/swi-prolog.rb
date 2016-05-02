class SwiProlog < Formula
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.2.3.tar.gz"
  sha256 "43657d51b7c5887bc2d2bced50a9822b86a08a6841399b8e76ee877f51d646b5"

  bottle do
    revision 1
    sha256 "d3d9dab5bb9f9ca0872ed6ecdff62fa09033775c3cb9f4f7b2a7f68f19c7a21a" => :el_capitan
    sha256 "b6911b7573958dbc4ea8dbae03c06080239ce990e62a106ca03cdb6a9399d05d" => :yosemite
    sha256 "193d6fc6f928dffda0826a1d01d04cfa6635764f4c343b0f14493a48455ebbe7" => :mavericks
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.3.19.tar.gz"
    sha256 "693cfeac8f31d050ddcec27e550586359e98a64dc820398997d0ce6b8f564354"
  end

  head do
    url "https://github.com/SWI-Prolog/swipl-devel.git"

    depends_on "autoconf" => :build
  end

  option "with-lite", "Disable all packages"
  option "with-jpl", "Enable JPL (Java Prolog Bridge)"
  option "with-xpce", "Enable XPCE (Prolog Native GUI Library)"

  deprecated_option "lite" => "with-lite"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "gmp"
  depends_on "openssl"
  depends_on "libarchive" => :optional

  if build.with? "xpce"
    depends_on :x11
    depends_on "jpeg"
  end

  # 10.5 versions of these are too old
  if MacOS.version <= :leopard
    depends_on "fontconfig"
    depends_on "expat"
  end

  fails_with :llvm do
    build 2335
    cause "Exported procedure chr_translate:chr_translate_line_info/3 is not defined"
  end

  def install
    # The archive package hard-codes a check for MacPort libarchive
    # Replace this with a check for Homebrew's libarchive, or nowhere
    if build.with? "libarchive"
      inreplace "packages/archive/configure.in", "/opt/local",
                                                 Formula["libarchive"].opt_prefix
    else
      ENV.append "DISABLE_PKGS", "archive"
    end

    args = ["--prefix=#{libexec}", "--mandir=#{man}"]
    ENV.append "DISABLE_PKGS", "jpl" if build.without? "jpl"
    ENV.append "DISABLE_PKGS", "xpce" if build.without? "xpce"

    # SWI-Prolog's Makefiles don't add CPPFLAGS to the compile command, but do
    # include CIFLAGS. Setting it here. Also, they clobber CFLAGS, so including
    # the Homebrew-generated CFLAGS into COFLAGS here.
    ENV["CIFLAGS"] = ENV.cppflags
    ENV["COFLAGS"] = ENV.cflags

    # Build the packages unless --with-lite option specified
    args << "--with-world" if build.without? "lite"

    # './prepare' prompts the user to build documentation
    # (which requires other modules). '3' is the option
    # to ignore documentation.
    system "echo '3' | ./prepare" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<-EOS.undent
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end

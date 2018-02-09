class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.6.4.tar.gz"
  sha256 "2d3d7aabd6d99a02dcc2da5d7604e3500329e541c6f857edc5aa06a3b1267891"

  bottle do
    sha256 "7a1a76d4b9160e0fea1899a8af0dcd448f71efef8476b1732d75e8d0339ac419" => :high_sierra
    sha256 "af00bfcc0da68a800dd50e608aabc6620db00de1a7bf1b986a7bc49ae58ea234" => :sierra
    sha256 "2016d9b076b252805f48f705181d03cd26183b0f74a026c029cd34f9e8afb79d" => :el_capitan
  end

  devel do
    url "http://www.swi-prolog.org/download/devel/src/swipl-7.7.8.tar.gz"
    sha256 "4123ceecd349c73eb1196ff04eb0ca77df5b60171016819ba4e9b9c132f0a032"
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

  def install
    if build.with? "libarchive"
      ENV["ARPREFIX"] = Formula["libarchive"].opt_prefix
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
    system "echo 3 | ./prepare" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end

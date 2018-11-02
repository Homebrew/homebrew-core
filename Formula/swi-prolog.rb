class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "http://www.swi-prolog.org/"
  url "http://www.swi-prolog.org/download/stable/src/swipl-7.6.4.tar.gz"
  sha256 "2d3d7aabd6d99a02dcc2da5d7604e3500329e541c6f857edc5aa06a3b1267891"

  bottle do
    sha256 "5076f120b7f2775fc0968885d2d0e82cb7a93f3040c1c39243abdd8ec3ba1e59" => :mojave
    sha256 "7a1a76d4b9160e0fea1899a8af0dcd448f71efef8476b1732d75e8d0339ac419" => :high_sierra
    sha256 "af00bfcc0da68a800dd50e608aabc6620db00de1a7bf1b986a7bc49ae58ea234" => :sierra
    sha256 "2016d9b076b252805f48f705181d03cd26183b0f74a026c029cd34f9e8afb79d" => :el_capitan
  end

  head do
    url "https://github.com/SWI-Prolog/swipl-devel.git"

    depends_on "cmake" => :build
  end

  option "with-jpl",     "Enable JPL (Java Prolog Bridge)"
  option "without-xpce", "Disable XPCE (Prolog Native GUI Library)"

  depends_on "ossp-uuid"
  depends_on "readline"
  depends_on "gmp" => :recommended
  depends_on "libarchive" => :recommended
  depends_on "openssl" => :recommended
  depends_on "pcre" => :recommended
  depends_on "berkeley-db" => :optional
  depends_on "unixodbc" => :optional

  unless build.without? "xpce"
    depends_on :x11
    depends_on "jpeg"
  end

  def install
    if build.head?
      swi_options = []

      swi_options.push("-DSWIPL_PACKAGES_X=OFF")    if build.without? "xpce"
      swi_options.push("-DSWIPL_PACKAGES_JAVA=OFF") if build.without? "jpl"

      system "cmake", ".", *std_cmake_args, *swi_options
    else
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

      system "./configure", *args
    end

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

class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "https://rakudo.perl6.org/downloads/star/rakudo-star-2017.10.tar.gz"
  sha256 "d52498b8838f168d654fa669cfc3abc5f4908d04e6c6e657ce2e14e77c8823b0"

  bottle do
    sha256 "f059d692769442861f7733a18a9786777204cb20e4d9e604816eec33dee8ba7a" => :high_sierra
    sha256 "4e31d5b909b4cb378fa9d7954eb441d0d6d87634cb441ebe47be7c367f94c37f" => :sierra
    sha256 "23e2b96d1edc0f41a1957d2233475169c711470b6181c9a52ec9d20d9ca040e7" => :el_capitan
    sha256 "f3c595ddda395ab96d36723acf939250bd597fbce98276c7e7547916d8b515b9" => :yosemite
  end

  option "with-jvm", "Build also for jvm as an alternate backend."

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "libffi"

  conflicts_with "parrot"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    backends = ["moar"]
    generate = ["--gen-moar"]

    backends << "jvm" if build.with? "jvm"

    system "perl", "Configure.pl", "--prefix=#{prefix}", "--backends=" + backends.join(","), *generate
    system "make"
    system "make", "install"

    # Panda is now in share/perl6/site/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

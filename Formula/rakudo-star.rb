class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2016.04.tar.gz"
  sha256 "6a5f6240512ceac4eaff6f2870b2e25d3e6cf146efbf61f353b797123c7fbf87"

  bottle do
    sha256 "81afc881911ab9bee8c6915561630228d226314297d999b32450af82d621126d" => :el_capitan
    sha256 "e881b3409ceed03e1723fa4f2cd895b3fab01c14d0d3fa5b933df9f8e5a297fe" => :yosemite
    sha256 "6efd5e1d9826746321d749150fd928b2bf50f4f2ebdc9b37e0f1d0967cf9d134" => :mavericks
  end

  option "with-jvm", "Build also for jvm as an alternate backend."

  conflicts_with "parrot"

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "libffi"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.j1 # An intermittent race condition causes random build failures.

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
    if File.directory?("#{prefix}/man")
      mv "#{prefix}/man", share
    end
  end

  test do
    out = `#{bin}/perl6 -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end

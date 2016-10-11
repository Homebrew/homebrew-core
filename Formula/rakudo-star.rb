class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2016.07.tar.gz"
  sha256 "6aa2c73da1c5c89e7495eaa0b572f07a3184b13df3e8eb6f452038c8023ffd33"

  bottle do
    sha256 "04721ad21f249bc0627b3cf6c3d99315a12abbfb7e36eb4ac9e36513d43b465c" => :sierra
    sha256 "c740b4227959695513023785d528290e6dbb3f88767f41855bccbb4987285b05" => :el_capitan
    sha256 "6c4b31f795b03ff581ccad8aff5da60ec108474b8d88db40560384c6a63f5afc" => :yosemite
    sha256 "83bb7e869fa7b2dc2a6677523c351fffb14f7900167091c8fa32baaa349d542d" => :mavericks
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

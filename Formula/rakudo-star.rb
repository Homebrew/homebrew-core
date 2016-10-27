class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "http://rakudo.org/downloads/star/rakudo-star-2016.10.tar.gz"
  sha256 "00fb63c1e0475213960298fac82a53906f1bfa8d431ca8c00ef278f58bf1d14b"

  bottle do
    sha256 "b63ee3f5622da6180abfa8bc172253a9c5f84fae97733df5e666ed5e75ff3cc5" => :sierra
    sha256 "4d944fad4fb0a5e91433038ed40c1a9df9956abc86fb7231ab1610c7e9626bf7" => :el_capitan
    sha256 "6f1f51602759579a958a00049ee5509711cbd91a17b2ae65f9dfdd4bf6cbf827" => :yosemite
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

    # Work around to prevent MoarVM from using clock_gettime
    # Reported 2016-10-27: https://github.com/MoarVM/MoarVM/issues/437
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      inreplace "MoarVM/src/platform/posix/time.c", "CLOCK_REALTIME", "UNDEFINED_XCODE8_HACK"
    end

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

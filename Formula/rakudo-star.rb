class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "http://rakudo.org/"
  url "https://github.com/rakudo/rakudo/archive/2017.02.tar.gz"
  sha256 "a9a16bef4d826e77d28a2ca7ffe7c1ccde2a236b7ec36a6522e54eb54ac11e85"

  bottle do
    sha256 "5cfef784285a5e46be149ebfc07cef95b41b9162e6925067dd6351ed1b37b4ed" => :sierra
    sha256 "4b4004ef1db0bee289176404a36611a987c362b92489ddbb46e5173c5b366099" => :el_capitan
    sha256 "99334acafe6eec093891ed0bfc17173c4a6e3dceb0722bb89edabb1f3d089726" => :yosemite
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

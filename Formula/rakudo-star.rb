class RakudoStar < Formula
  desc "Perl 6 compiler"
  homepage "https://rakudo.org/"
  url "https://rakudo.perl6.org/downloads/star/rakudo-star-2018.06.tar.gz"
  sha256 "309fbaaf441866ee9454451e83e90e4a21391944d475eacda93f48c7671da888"

  bottle do
    sha256 "eef94343a56257d5784697cbf599af9405ae232b011e1a1c326efc0491cade66" => :mojave
    sha256 "d67db94ca0b2fb416692526612f7221a7c3ba3e16c7806fa8915d41f6bf41675" => :high_sierra
    sha256 "acface64bccd27b0b25881386e8785650abcfbddce7c04fd678762c35373925f" => :sierra
    sha256 "c3d5e16417976c4d4387f1b3f2bb0cec298371fe12567d8e72c052d3644d69ab" => :el_capitan
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

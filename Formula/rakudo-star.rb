class RakudoStar < Formula
  desc "Rakudo compiler and commonly used packages"
  homepage "https://rakudo.org/"
  url "https://rakudo.org/dl/star/rakudo-star-2021.02.1.tar.gz"
  sha256 "1c9546fe115d49bf115cdb15b89bce27c5d24e2c1fd95a03c8853a46cc87e2a0"
  license "Artistic-2.0"

  livecheck do
    url "https://rakudo.org/dl/star/"
    regex(/".*?rakudo-star[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:     "aeb7eb041a03204bf11a556e24a6da57d0b9eb55ec8c6179f54e6f6b0b8d44cd"
    sha256 catalina:    "1a9933d90e4c95b895cc712f267bf38ad4bf40c0170869e46ebe9dc35855f9d0"
    sha256 mojave:      "3d8cb747d9a1c9131637cc25b8fc32c6844a9113096eb3a9ccb28c6d69ea363f"
    sha256 high_sierra: "6fc9f0fe77b7a692431d85199633353df82b6c409dc754162c04d0ae26843b87"
  end

  depends_on "bash" => :build
  depends_on "gmp"
  depends_on "icu4c"
  depends_on "libffi"
  depends_on "pcre"
  depends_on "readline"

  conflicts_with "moarvm", "nqp", because: "rakudo-star currently ships with moarvm and nqp included"
  conflicts_with "parrot"
  conflicts_with "rakudo"

  def install
    libffi = Formula["libffi"]
    ENV.remove "CPPFLAGS", "-I#{libffi.include}"
    ENV.prepend "CPPFLAGS", "-I#{libffi.lib}/libffi-#{libffi.version}/include"

    ENV.deparallelize # An intermittent race condition causes random build failures.

    # make install runs tests that can hang on sierra
    # set this variable to skip those tests
    ENV["NO_NETWORK_TESTING"] = "1"
    system "bin/rstar", "install", "-p", prefix.to_s

    #  Installed scripts are now in share/perl/{site|vendor}/bin, so we need to symlink it too.
    bin.install_symlink Dir[share/"perl6/vendor/bin/*"]
    bin.install_symlink Dir[share/"perl6/site/bin/*"]

    # Move the man pages out of the top level into share.
    # Not all backends seem to generate man pages at this point (moar does not, parrot does),
    # so we need to check if the directory exists first.
    mv "#{prefix}/man", share if File.directory?("#{prefix}/man")
  end

  test do
    out = `#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'`
    assert_equal "0123456789", out
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end

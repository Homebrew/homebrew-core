class Rakudo < Formula
  desc "Mature, production-ready implementation of the Raku language"
  homepage "https://rakudo.org"
  url "https://github.com/rakudo/rakudo/releases/download/2025.04/rakudo-2025.04.tar.gz"
  sha256 "6569878db3bbf02c19c9280f7583fd581f75454d9408b847b8360e544bc7fb98"
  license "Artistic-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "119377d1090b2eac475b94c5ec543513a02151773ae974c25632f64088626df9"
    sha256 arm64_sonoma:  "c5ea837d22a9dc4d7fd42920e774b34e8f22629736105e7cd7d3b74c209b78b7"
    sha256 arm64_ventura: "bef700ae08f17252cd63dda124a38c980c1b0462c0efecca238ac0cf01329501"
    sha256 sonoma:        "978af772b09dabb48256d9ca7383f7d43edaa0169b4851b30b1bc9d51e7497f5"
    sha256 ventura:       "70c1e8889b31e0a320c13c2eb8af99a90bbe3bf3e97b731ed52ddaa97766ebcf"
    sha256 arm64_linux:   "b7d3f1aecfbaff20c1dd421c23cfb8bbade1e345b0c27de4614c977c1bbdaa46"
    sha256 x86_64_linux:  "a4ec1ff159add1f020be9193fc1dd66485a7bad5449fe6f582e6d9ade444c305"
  end

  depends_on "moarvm"
  depends_on "nqp"

  uses_from_macos "perl" => :build

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl",
                   "--backends=moar",
                   "--prefix=#{prefix}",
                   "--with-nqp=#{Formula["nqp"].bin}/nqp"

    # Reduce overlinking on macOS
    if OS.mac?
      inreplace "Makefile" do |s|
        s.change_make_var! "M_LDFLAGS", "#{s.get_make_var("M_LDFLAGS")} -Wl,-dead_strip_dylibs"
      end
    end

    system "make"
    system "make", "install"
    bin.install "tools/install-dist.raku" => "raku-install-dist"
  end

  test do
    out = shell_output("#{bin}/raku -e 'loop (my $i = 0; $i < 10; $i++) { print $i }'")
    assert_equal "0123456789", out
  end
end

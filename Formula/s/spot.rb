class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.16.tar.gz"
  sha256 "688463cb2fa393c51d9cf938fb01a716b91e4c8122aeb52fd116a3bbfddab869"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e1ec26a525add4518db370bba777082d78fcfe3c1dff62cefd652b5e6303cfc8"
    sha256 cellar: :any, arm64_sequoia: "0cb35760e6504fb34e0dbafbb61ba7cf0b725a767dd98fd0faefbe19a98368d6"
    sha256 cellar: :any, arm64_sonoma:  "1ea411402fe46689720ab8705b27916dc1bb5ca46d2e74ef89686c5f905b9811"
    sha256 cellar: :any, arm64_linux:   "aebb085071607f69116e6dd7fa8b4844fdd28b53312b171187e75f3b32252936"
    sha256 cellar: :any, x86_64_linux:  "d0e8428cda3ae1e2683b14afacc618ea321c522b45011000a6721b0c5d5ad65a"
  end

  depends_on "python@3.14" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    randltl_output = pipe_output("#{bin}/randltl -n20 a b c d", "")
    assert_match "Xb R ((Gb R c) W d)", randltl_output

    ltlcross_output = pipe_output("#{bin}/ltlcross '#{bin}/ltl2tgba -H -D %f >%O' " \
                                  "'#{bin}/ltl2tgba -s %f >%O' '#{bin}/ltl2tgba -DP %f >%O' 2>&1", randltl_output)
    assert_match "No problem detected", ltlcross_output
  end
end

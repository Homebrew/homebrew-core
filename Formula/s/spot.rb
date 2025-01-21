class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.12.2.tar.gz"
  sha256 "f2785a47faa6732bc7baec7c39468c443d37c8adc7f42faa1258761954a96bb4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "82c09d875f4e37b130c36270f35f83fb4ec296a5f62620adcee6cf7ad9b71f4b"
    sha256 cellar: :any,                 arm64_sonoma:  "7a6a26e2561b4420d81d9dc14e183ddeb3abc291cddae35f45dd124c17ad8c2a"
    sha256 cellar: :any,                 arm64_ventura: "7f798e72df761b27eb9546475ceb39dfcb8c164f9e07dfad789cfc5ca804b71d"
    sha256 cellar: :any,                 sonoma:        "48fc323e63d1e0d7efc50a44ece6301fa03983a4b6df4596e43be9d7f01b0b34"
    sha256 cellar: :any,                 ventura:       "2957d881e871e1168b47668b2c5d066f0bf92ab762a028ce9048d0b6c9b6c1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f43e975ba5ef966d887256c7674e2b7b5755e54dbf5311f2b506fb80dc00fe56"
  end

  depends_on "python@3.13" => :build

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
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

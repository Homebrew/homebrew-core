class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.16.1.tar.gz"
  sha256 "182f4180da851588886a2e5f1540c3e2bb5cfddd228fd20689fa7ce498f57733"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d0ab49c0e2df40335c442a4ddb17d58b3fa62ccf44c2c96e894b183ab4bf0490"
    sha256 cellar: :any, arm64_tahoe:       "ce7aca953b5ce1063c7c3fc8f31c69d1a23db9293ef71a23b30751cb37051499"
    sha256 cellar: :any, arm64_sequoia:     "579e7a211d41eb04e3002756256341f0927c1071cf7844e5a4e7fea329e0e48e"
    sha256 cellar: :any, arm64_linux:       "6bcaae517d55bc35af9664cfbad9b8a7e821a37bd720e821a1b70ff47a1b9963"
    sha256 cellar: :any, x86_64_linux:      "ae7a9d7ae8681eb04d4f7831e109ff42f8baadfb1ede99cfea323b7fd289a541"
  end

  depends_on "python@3.15" => :build

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

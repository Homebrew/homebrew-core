class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.16.2.tar.gz"
  sha256 "52f8d06cf9bf1ae1b4309ec5d3419ef74ef5c199b71c70a2352e4c4f0a2302ac"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "810ca53a1c1bd043e52973057b0d072ad50d0203dd6f1305ed866b76fe4ae49d"
    sha256 cellar: :any, arm64_tahoe:       "a736a4a9a4bc2d952a5797bcc454012fd15562e4146651562635f2a6b190cb61"
    sha256 cellar: :any, arm64_sequoia:     "d428cbf5c79e3bcf8d1691ef2df43e1b483ff14a913c66e6ce6db27732042d03"
    sha256 cellar: :any, arm64_linux:       "6f269997e9595702d0892033ef365cbd01146c6254b3a786c69cebec79a08d47"
    sha256 cellar: :any, x86_64_linux:      "208c2770131ec30f14badd9159b18e419c27f39cfcd514ad2d47cb34b907682b"
  end

  # Use Homebrew Python for C headers
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

class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.16.3.tar.gz"
  sha256 "c17eb7f3d7634c8b4e1587ab37303a118805bbf5740bdd28e90589db3c7d2034"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "95d0d283e02a4b8fd54d2fed3e819f6680c744425f4f98ec3a60d9922edb2857"
    sha256 cellar: :any, arm64_golden_gate: "81d7fdd0b4950782364aa3916e5da0bfb7078bb28bbabb8e3a83fdfb6516c283"
    sha256 cellar: :any, arm64_tahoe:       "d7e316cda28c8730c444e7f926fda350113cd506221189ba0f09381698e64102"
    sha256 cellar: :any, arm64_sequoia:     "7ef567f4f5724b91a4ee3a91e323c2379db55de57d47787567ff6a6d9d95d471"
    sha256 cellar: :any, arm64_linux:       "543c799ccebf0ccf4ca3a10b4dc1e42f221eb060c4f4f69f0b08c26908bdff59"
    sha256 cellar: :any, x86_64_linux:      "9bc6ca20d852e002adb3e2b33889a648ba2bca1f894c1910edf684c3aec370bf"
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

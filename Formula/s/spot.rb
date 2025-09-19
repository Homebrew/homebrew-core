class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.14.2.tar.gz"
  sha256 "a5142aa9b13b3623cd9c1f09b485542f8cdea3e0a2fc6116eea36eb0fc19af19"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "86c61c9ce1c883c3f526b244b71513a65f59bc2e288de316a8a51c7e390b4b16"
    sha256 cellar: :any,                 arm64_sequoia: "bdcdf2c6e0cdfdb069e1f441515093ff6de5574dcd96573db4e92be42b60f37c"
    sha256 cellar: :any,                 arm64_sonoma:  "37ab56362819a8b1acc947d3ed019ac65fdc5d1bfc3bcd292212019bbaec1d85"
    sha256 cellar: :any,                 sonoma:        "5a96cfbea1ebc4f17f31ed9e3a067cf8b104e34c7a66266aa960c41783da24d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2972e9c0a4e173fba2f10ded58fce3e595df7011e1578ede135a330db9b4a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b23f29a345f506db9db27633b3386b3171f53262825b7bcfa8dd768035c3e109"
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

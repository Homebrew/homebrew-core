class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "http://www.lrde.epita.fr/dload/spot/spot-2.11.6.tar.gz"
  sha256 "a692794f89c0db3956ba5919bdd5313e372e0de34000a9022f29e1c6e91c538a"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da6a0bf4b6504b15be13b47a9b45ad2fb1cd573b099081597f5ef49b6678a3b9"
    sha256 cellar: :any,                 arm64_monterey: "be6f4d8f6bad04c2ce15fc353f17ef53b89567a31f2a0c93c83ac43b425191b8"
    sha256 cellar: :any,                 arm64_big_sur:  "eebc434b54f36eef7ceee02079d267b73969ff3673c64604d6d7ae1ab7730255"
    sha256 cellar: :any,                 ventura:        "c823bdf1d266af19b3b10ca6ab90136fe4c02eff446585dd797fd280a907b1f0"
    sha256 cellar: :any,                 monterey:       "dad4012d3966c40b24151d3751d3b1552bd388bb673c367412080b27e0496af4"
    sha256 cellar: :any,                 big_sur:        "0aa2bb9b33ff61844ac4c22b7785c9613db59e6b4da1ab13d83097ba75579141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7087a187f5f60917e98f9cb6c2262c67ab02e926510ef024f7028615c49a8e2f"
  end

  uses_from_macos "python" => :build

  fails_with gcc: "5" # C++17

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"randltl -n20 a b c d | ltlcross 'ltl2tgba -H -D %f >%O' 'ltl2tgba -s %f >%O' 'ltl2tgba -DP %f >%O'"
  end
end

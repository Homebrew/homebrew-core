class Spot < Formula
  desc "Platform for LTL and ω-automata manipulation"
  homepage "https://spot.lre.epita.fr"
  url "https://www.lrde.epita.fr/dload/spot/spot-2.13.1.tar.gz"
  sha256 "b9d1de4abcd069f923e1a3263f58ccafcc54896aa818b455928ca2b1a4466dc9"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.lrde.epita.fr/dload/spot/"
    regex(/href=.*?spot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d515aee932792bd7473a2b062a3d6aec2359a57478d79feac44b0ff991bf882b"
    sha256 cellar: :any,                 arm64_sonoma:  "d62b1d2427fe1faa94d027dd06fc7953261edb275b3649f1399da3a3e036da13"
    sha256 cellar: :any,                 arm64_ventura: "18cb2c3876c10b5d546390a4ddd297497491e10e11a09c7d37a7e8bfa8c995a0"
    sha256 cellar: :any,                 sonoma:        "7dd821d2fda923457b8eb993367a94333cea891b9482f8ec6923da938eb9b677"
    sha256 cellar: :any,                 ventura:       "3ec81346e00152d9635aa757e1ea13cd510f878e7fb6c3f11c2c402956d7a9ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5777648e4a06ef9c4cc634b38f6d3102f01bda9976ff214d1b51603bcb3afa1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99ad6dc363664791bfba111064393043c9e906494b64279ab5f4204fa145ac6c"
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

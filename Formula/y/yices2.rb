class Yices2 < Formula
  desc "Yices SMT Solver"
  homepage "https://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/refs/tags/Yices-2.6.5.tar.gz"
  sha256 "46a93225c1e14ee105e573bb5aae69c8d75b5c65d71e4491fac98203cb0182f3"
  license "GPL-3.0-only"
  head "https://github.com/SRI-CSL/yices2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Yices[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7aa9455d40cdd55ef92337c0216bbd59eb9a79436112ba5048371762c2ef6447"
    sha256 cellar: :any,                 arm64_sonoma:  "0ebe8f48d46ba45ce6f51e16731dc13419c44274b68909ed9635dcb13b6387cc"
    sha256 cellar: :any,                 arm64_ventura: "e9f1e7539230db974013b318edcb79b903d4481f535412a15a011e8db1e848a7"
    sha256 cellar: :any,                 sonoma:        "df4295c2f41d0c4615eddc34ec1a6027ac42f1878ef5a480073b9173e6694966"
    sha256 cellar: :any,                 ventura:       "e6ef02af7980cac20b6421c387b7273c96526b00979764eed016201d08ae2f4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab2b4ae5de11f2261d60972181d48b4174c90a9a0c1eaaba39a7ede75d16d4b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e262428f6fe4f84fb209b35479ed9210fa975ec908120e77dcea8f797fc6752"
  end

  depends_on "autoconf" => :build
  depends_on "gperf" => :build
  depends_on "gmp"

  def install
    system "autoconf"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"lra.smt2").write <<~EOF
      ;; QF_LRA = Quantifier-Free Linear Real Arithmetic
      (set-logic QF_LRA)
      ;; Declare variables x, y
      (declare-fun x () Real)
      (declare-fun y () Real)
      ;; Find solution to (x + y > 0), ((x < 0) || (y < 0))
      (assert (> (+ x y) 0))
      (assert (or (< x 0) (< y 0)))
      ;; Run a satisfiability check
      (check-sat)
      ;; Print the model
      (get-model)
    EOF
    assert_match "sat\n(= x 2)\n(= y (- 1))\n", shell_output("#{bin}/yices-smt2 #{testpath}/lra.smt2")
  end
end

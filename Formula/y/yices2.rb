class Yices2 < Formula
  desc "Yices SMT Solver"
  homepage "https://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/refs/tags/yices-2.8.0.tar.gz"
  sha256 "cb4c58c3508a5e67c156ba26182cd540af644fb7ba39b2873feebf73f21201b2"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/SRI-CSL/yices2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Yices[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4ce4c4f2aa8190ceecfd662d631e0106a29201a32226455b902c42601e39adf7"
    sha256 cellar: :any, arm64_tahoe:       "e551b9cf6ef4baa43bcb645cfa8f72a404e1f933cb7619589c66d7b31103f94f"
    sha256 cellar: :any, arm64_sequoia:     "cee3136d1316e9c1af807b116eacec2dd1736483ec712b8b7481fb4db0cb0524"
    sha256 cellar: :any, arm64_linux:       "829f9a848ed6e72cf964490faa4c772ae608fd808da94569342a443a1f69cded"
    sha256 cellar: :any, x86_64_linux:      "a7f3fc3b9382f24780cd8c15f68140503046192858781f9e90c1b8f8981c24d0"
  end

  depends_on "autoconf" => :build
  depends_on "gmp"

  uses_from_macos "gperf" => :build

  deny_network_access!

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
    output = shell_output("#{bin}/yices-smt2 #{testpath}/lra.smt2")
    assert_match "sat\n((define-fun x () Real 2.0)\n (define-fun y () Real (- 1.0)))\n", output
  end
end

class Yices2 < Formula
  desc "Yices SMT Solver"
  homepage "https://yices.csl.sri.com/"
  url "https://github.com/SRI-CSL/yices2/archive/refs/tags/yices-2.7.0.tar.gz"
  sha256 "584db72abf6643927b2c3ba98ff793f602216b452b8ff2f34a8851d35904804a"
  license "GPL-3.0-only"
  head "https://github.com/SRI-CSL/yices2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^Yices[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2df989805c717cb45574f0bf1d84eabdec50cf4d5748a9f1f8bdbf0cde5c9fa2"
    sha256 cellar: :any,                 arm64_sequoia: "d94ae8d40c3a882393d36e3f868f9dde59c24beb2202b483063a5185075139ee"
    sha256 cellar: :any,                 arm64_sonoma:  "c250094bd74818ddb24ea16c6ebe228f2b096e2cfad0823e81c15968cd8bb915"
    sha256 cellar: :any,                 arm64_ventura: "acb1d683ad88ff73884a8763b4be8a6a8ef2191e1e0c9bb4f1148ad567b6fe9f"
    sha256 cellar: :any,                 sonoma:        "a96677d6a211fad706027741156659a27248c92cfdc551af54320447b60c6541"
    sha256 cellar: :any,                 ventura:       "43e43decf3e87e3f9d0dea527de3716dfe4bebeae53f284770febd4e999a5d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c7c20fd75460a7097c96078649acb02fce6c2d0a51612e87c2f2471840358c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2509483f7fa18241b1a4005a408ec700e5c4e5c567e0e63d6f7f1f783b179bbc"
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
    output = shell_output("#{bin}/yices-smt2 #{testpath}/lra.smt2")
    assert_match "sat\n((define-fun x () Real 2.0)\n (define-fun y () Real (- 1.0)))\n", output
  end
end

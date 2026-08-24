class Vampire < Formula
  desc "High-performance theorem prover"
  homepage "https://vprover.github.io/"
  url "https://github.com/vprover/vampire/releases/download/v5.1.0/vampire.tar.gz"
  sha256 "80a4c52237618d451a344d1fbb42c932992b4eb1633049a9516a37501819ce25"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "03f7dad715035dd222387a3631ece4133d90b54d89955cd2930a32fb56354bf2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "722420c1fb9b5e812d831ee663fdcbc00ded8f25c8e5f7066bafb292bff6812e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20196b618f28eacd86372743f549e36763642b262421e0663c77699bfe5545e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "89da007d0b6fb41231aca6bad7cd4f2e956c482384bd09205428d94af43e8ddd"
    sha256 cellar: :any,                 arm64_linux:   "9b614fdded0ae6a296fa5dcdc0c9876472c2e1a0bc871c695b391a4d3955f13a"
    sha256 cellar: :any,                 x86_64_linux:  "8eeeb7b30593bc00d0170f3727f1ec99a5ba5276e8c6f04c68118ded997de35c"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Clang 16.0.0 crashes due to a parser bug"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.smt2").write <<~SMT2
      (set-info :smt-lib-version 2.7)
      (declare-datatype list (par (a) (
        (nil)
        (cons (head a) (tail (list a))))))
      (define-fun-rec sum ((xs (list Real))) Real
        (match xs (
          (nil 0.0)
          ((cons y ys) (+ y (sum ys))))))
      (declare-sort-parameter a)
      (define-fun-rec concat ((xs (list a)) (ys (list a))) (list a)
        (match xs (
          (nil ys)
          ((cons x xs') (cons x (concat xs' ys))))))
      (assert (not (forall ((xs (list Real)) (ys (list Real)))
        (= (sum (concat xs ys)) (+ (sum xs) (sum ys))))))
    SMT2

    system bin/"vampire", "--input_syntax", "smtlib2", "-ind", "struct", "test.smt2"
  end
end

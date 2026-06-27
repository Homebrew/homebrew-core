class Vampire < Formula
  desc "High-performance theorem prover"
  homepage "https://vprover.github.io/"
  url "https://github.com/vprover/vampire/releases/download/v5.0.1/vampire.tar.gz"
  sha256 "3d991c914e9f400641d8b2e4362065c218c0ecb08079b96b0da1714aa6842520"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7ddec00fee445a0e1bfd5caca53a28e4a30e41fcb0cdfe4e9c5497bfc78f70d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0cd98ea75f19465e88f05a2da929d1758c71989744ed1035d58413ca5a0a16d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bedd8ba34e0e8e1f5752b14cd7c812787f3e3cec5f2b2b7a74d6e17cced04fba"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6b03fb0f7a8a6461626d8548a762fe7ae49d5c42792a47758cf2ccf45e7e333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41ade77fd28eef439c3133270c8f8f99ee598266d5b83243ebbe79f99b62632d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c71ff5f94b3d9cfb3a346e2c0c85c3b16ec51a378f8b201fccd45657d4ee104"
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

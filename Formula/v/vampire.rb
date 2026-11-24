class Vampire < Formula
  desc "High-performance theorem prover"
  homepage "https://vprover.github.io/"
  url "https://github.com/vprover/vampire/releases/download/v5.1.2/vampire.tar.gz"
  sha256 "b90c97f24af05689b78218788bc8a5438016b340ca725c78b1c5e97aa9f0ec5d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "1621cbc922cbbd3204ac422905f49f7fd0a510068c1a8bc034252d784eb2aa0a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a13da61c979eb8683edc6a9463872332c817634e651e2f275f1467e986555d19"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2e8295fb3b8ddf45cb792430856c5c555125d31a43f2ecd131d89b0b8ab536d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9a2961eca77e5de741318d99970a2ecbb3672d2077eb91c6a9310ab728dd27e4"
    sha256 cellar: :any,                 arm64_linux:       "741aa65ddf115d2333acb42942caf86dd9e94a053955000050b38554d62df293"
    sha256 cellar: :any,                 x86_64_linux:      "a1ac00dcd0909c7c63c98b383a78d22b73808756a3d3e042e0278d6228fa29d3"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
    cause "Clang 16.0.0 crashes due to a parser bug"
  end

  deny_network_access!

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

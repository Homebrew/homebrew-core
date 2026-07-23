class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "d460a74fa6e20c048bef3582b4eee92a4c94f32a95777c43cd697335443246f6"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "803e7128d97f90c79ba8911fba8427524e649c083eba7f1249f0b2cae3ab5825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a51bd5053a830b1f3a381b0d49e24d3922fd93b061cec206e46a0614111e7bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a6e9dc98fc710c1ec5ba8bc55f55f0845ceb2c7a32e5261aa931a8ff1cc4395"
    sha256 cellar: :any_skip_relocation, sonoma:        "94fa7083205e7d045f7e8db65375c09537f1f3776f83dafd043302cf79cabc0b"
    sha256 cellar: :any,                 arm64_linux:   "cb40a492e7bb978ed493c3068146f80b35ef7e926455c4861a39e027a8b75675"
    sha256 cellar: :any,                 x86_64_linux:  "5683ae1e4148fb66e8696ee724a464cdf17fcf348bcce831966173ffac053ea2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/salmon-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/salmon --version")

    (testpath/"txome.fa").write ">t0\n#{"ACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGTACGT" * 4}\n"
    system bin/"salmon", "index", "-t", "txome.fa", "-i", "idx", "-k", "31"
    assert_predicate testpath/"idx", :directory?
  end
end

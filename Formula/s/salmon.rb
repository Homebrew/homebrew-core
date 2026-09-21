class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "95385ffca31017f2a7910ed6b1e46157cf8722fcefa9aecf3fd34fbf2fe7b038"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54cd84efbe529bf117e071e0ab58ef9a6f20c3adbff88c98ff316b7697f715a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "81e6255898a2b81b7f25468ee2705314b73abfb68f0a895ee033192ee41b6823"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "55c1f472c5d5495fa26b37c707d80e6ec3c0b3c474d43d1fbbc9df814ac5cae8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "5df9960d4f270fef1a35b001de7dfa548dc1e9c09b75858ba0411d30c5988cf5"
    sha256 cellar: :any,                 arm64_linux:       "3c4e0b309ea4dd8c09377a93c55d202a393aca2eaad81b1e0a8626d50d7f53e1"
    sha256 cellar: :any,                 x86_64_linux:      "b85a622bc5d53955078e5c6c285c4e6b0d0ac478c84c6f524440d8efd26fc038"
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

class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "69672e45ca0e60a8df0d0cd33d8cbb9b8cd1c8d8c6d980650ac751a753163dfc"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cd5767bb46be1884321b58f1a17be809fba357f0adbdf0af169fc9fc43da563d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e97c1b4f6016f43578951bfa5ae38dc5d8c0c30ac0aa556aaea43b2e337fc487"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3b44b39e22ee0c9e43a2b1585b77c8ce11f1bb59c2e6d2e488fc7ca0110565bd"
    sha256 cellar: :any,                 arm64_linux:       "803edac36c0b377827404dc9170c3d79a50d6f1143baf4de775e14bfb3d0bb93"
    sha256 cellar: :any,                 x86_64_linux:      "7c80b7944a547d46e3846f80487449a39466071f9e9c5a692dc030385a5700d1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

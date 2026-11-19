class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.12.0.tar.gz"
  sha256 "af408eaeeb08274e65ada719c5e5a9ad79b15c5a51c7590f81ef2a66b2d3571c"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bec10e4fd026be395a4ee180e01fd05dc65a717a62c8b68c642fa9887375fe99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "87796ad5e4ed67338b7d218ce24507957936c2b21029f16985d9bad1dde8f861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68b42450a3446b780301ecc63388fc1b6a02016e83f81bcb5ca3b9bd3c4ca716"
    sha256 cellar: :any,                 arm64_linux:       "261c6b6fdd6dc8de8c45b12f1af7883ed5622acd879baf6add9e95661e74bc6a"
    sha256 cellar: :any,                 x86_64_linux:      "ab158bf9990fa4e6f188aea1c67c0e28b7687a7fd4536b0e7d901d92532c882a"
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

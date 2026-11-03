class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "2c1ac16c8e176772f714d78a74b80e4e86ef01f7c7e71e8e6b3341dd30a88492"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "251af50093d2f139406240255862e0e87217f46281297c07e680a7b04b8dc330"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "745aa924dcec4c3b2369a289051339c8f2592f5d4769451692de0a7b25f96fc0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "08846021b77711e142cd4227367069111acf8a68cac0b469c6f95ad882022fd1"
    sha256 cellar: :any,                 arm64_linux:       "1d0555df58a5bf66c207cffe092042c6c9a8dfed2667a3774871ba5153906fd2"
    sha256 cellar: :any,                 x86_64_linux:      "7ba31c59c9591e3acc9b17a6522ace33a1b5b2a202657cef0f40cf7c1ba40f8b"
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

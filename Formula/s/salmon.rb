class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "298e6fe9980e4d60e4a4ca8f043d3446e6a1ed0777487331224151eb93ae7dd4"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "38d6e3dde376b9942d4ab997af0495669fd5d9a3c413868dfea556eb59b375a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1b0400dd176161e753b3bcc97dd1e34aaae9761db3749006d8fedd647839b1d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a73c59b0c8adc359fcd058d510858109716a5349200d2704a7b010a9b7ff4a01"
    sha256 cellar: :any,                 arm64_linux:       "7c94a9e80b23c2bb8b513b8f5961a3e9ae63daa3656bd13c0dc74c7e41ee0e70"
    sha256 cellar: :any,                 x86_64_linux:      "4212c65463ebce7ae3ca5d7957f87dff3ec333ebbf1219d3ffbc0de0aa00db2e"
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

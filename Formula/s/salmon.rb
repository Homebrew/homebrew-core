class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "69672e45ca0e60a8df0d0cd33d8cbb9b8cd1c8d8c6d980650ac751a753163dfc"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eb129214e6da271bfd80bdf7ab73101323f3343681582596de4729eb5749abd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cd2e4543fd3da2d36e3c220d24f5aaa28257de15c1a0dcd4bd652e0399bee114"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "54059cd3f1c53469752c8847185933f1382126243a24a9b14db8eb65e5b155ac"
    sha256 cellar: :any,                 arm64_linux:       "c9404be246d807168c48e03bf1166107a93c9e1d75ed098a3fedda6f66df1ac3"
    sha256 cellar: :any,                 x86_64_linux:      "dc21397bffb64e019ce9ea0514abf72899a74c261802ff1f15f8047e1efa9e22"
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

class Salmon < Formula
  desc "Transcript-level quantification from RNA-seq reads"
  homepage "https://github.com/COMBINE-lab/salmon"
  url "https://github.com/COMBINE-lab/salmon/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "4a5dfa5040d6e0578003623a6123743b49a2976614a7b24391ade081868a18d0"
  license "BSD-3-Clause"
  head "https://github.com/COMBINE-lab/salmon.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a02c4fe6de44f2a66b3c43fa7212f4ad1b1f193107dd41a8a5f38d31443b4af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ab4b4bbbf9e949c48b6acd29937a0fdc8aae734b1f27cdb6773093b5643a37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "273f84f65cd8145ae2a783ac03b7338398ce39795433d4f1a39b0f039403c16d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9be34fcd5bd02ef55069939dd622ab4538bc82ea27f2207a68a667a127b3dc"
    sha256 cellar: :any,                 arm64_linux:   "580a1dd31305450a7b2efdf1d8725bb894fab336f709f04c5e83cf17eeb4cf6e"
    sha256 cellar: :any,                 x86_64_linux:  "0f8e4db40375175794969c4aeb147b3a905c5d6ff93fe7123e3a659ff876b247"
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

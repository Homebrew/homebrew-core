class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "5cae2fc3b8c57881fd9d3494c372eb8c8703eb69900513bfaef01f8892c55ae0"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "137e39a846e64d1a17d0a02714910e1ce05d554ec9cdfc229700271db407ec41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d43f0b4c13a9a4afd313c37eb93c2b89e164e2176678715e35383231d636033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e50a575e21c93500424351eae6562bc74a98666231c31b7763391f6220c6db5"
    sha256 cellar: :any_skip_relocation, sonoma:        "71e1da005539c47dc3910cced0e526cc025c8b8beb170e6822e1182109f14b52"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "638ff917ed6a9482d53e412ef5930fd687282dad76fcddf617edf5673ddb2040"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "172570f197be852d7b640de7b4cecf3250b7bc148d8042cca84a91608f4af933"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "test_files"
  end

  test do
    cp_r pkgshare/"test_files/.", testpath
    output = shell_output("#{bin}/skani dist e.coli-EC590.fasta e.coli-K12.fasta")
    assert_match "complete sequence", output
  end
end

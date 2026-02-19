class Trimal < Formula
  desc "Automated alignment trimming in large-scale phylogenetic analyses"
  homepage "https://trimal.readthedocs.io/"
  url "https://github.com/inab/trimal/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "58751054861b152e92214ff8c01a132071230614e8e777a7c9280d03648cde3b"
  license "GPL-3.0-only"
  head "https://github.com/inab/trimal.git", branch: "trimAl"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1fe61c76b43717d3473edb88ac31f0fe55bf01d25b0aa1dc707eb65eb2cd6cc4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d28a79bf9a963f31e2da9300c02cd2014c8faa575540bd6516818ec3b27ac5a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "559d64eafda467297422c13c3086d2d9fe25fb975bc6ab1ea9df513c905e4435"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be9d1d1dccd3dcb6fb0993819c342136ffce1a8bc2c39cd665d669df5361f51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a141a6f76311ad740ed1e6b83d62b031d9c8cc957b803bd8cfc82553d92a7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c30eb8f10dbe34b3966809eed08575df37d44030305ef9ce5926b5aa00c838e5"
  end

  def install
    cd "source" do
      system "make"
      bin.install "readal", "trimal", "statal"
    end
  end

  test do
    (testpath/"test.fasta").write <<~EOS
      >U00096.2:1-70
      AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC
    EOS
    system bin/"trimal", "-in", "test.fasta", "-out", "out.fasta"
    assert_path_exists "out.fasta"
  end
end

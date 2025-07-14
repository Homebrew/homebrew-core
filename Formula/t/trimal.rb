class Trimal < Formula
  desc "Automated alignment trimming in large-scale phylogenetic analyses"
  homepage "https://trimal.readthedocs.io/"
  url "https://github.com/inab/trimal/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "3fba2e07bffb7290c34e713a052d0f0ff1ce0792861740a8cec46f40685c6d73"
  license "GPL-3.0-only"
  head "https://github.com/inab/trimal.git", branch: "trimAl"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7601f4fa41f4b2c49221fcfd10680dae2d7ba2ecf7b118ada2626df50b3dfe56"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d9046969829e57b325ddb627977fccaf33ec9b3b9dd17fdd1acec4c45af0ed7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a64b8c35e66ccd823b1778665bebc09a42c5d630897591c18fd8b50b68f9ec6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b995bc17baddfea2602992cf14f32151e5e96967fe64d4fb75b11529b47f54c"
    sha256 cellar: :any_skip_relocation, ventura:       "c08772fe873d74045bb407315005b425aff589897efa1e76bd505c7e78d6200e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c0979024f0c970c93afe487233d6847fc182f23f00e8a89a88eca999a318ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdf2569d36a67e7381636245466bc4747821e04db83d1c6883b9a632920054f"
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

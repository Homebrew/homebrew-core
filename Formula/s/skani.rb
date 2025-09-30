class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "cbc35210acbe02da284cf1c7cb7d6b061cc943d2ff44a8d3e2aae68704545af6"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd6c7cad61880099bafc183919531c2cea2b24e6305c6a11686044855a45ed82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65dec55b820121a4e47424587d3f712181c717988548065ed47b42c5b8df9423"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6328346bcaaf38631e2c0dddaadfadf1e2a4889894f39eebbd50e964385a7b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8bc754751beec16c86cddab174a93e0befdf4d353a65dc3c628237079ba43b3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "856b80780da3c78ace5da7d8945daa832a6d3802e5e8c2db039759ce00ca8575"
    sha256 cellar: :any_skip_relocation, ventura:       "5e7dc2d3550ce1ed8b614b3bb7e77f10fa29e6c76fa8549e3272c5a531b8e74a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb21fb8cac917ffc3174b8453d5b098dcbe50445787bba01d34f84b5e343c115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfa225b2dde1dfc88c0967ccafe8dbfc9001fa6a8cd9d916486aae7c70102e3a"
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

class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "e047d52b9f753625eff480fe90f1abb68f82cc6892d9d1910b18bfcedbfc0b9d"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9cb6481c4334cccd0a6e3726ef1accc7f03f916949d6c04cbf57bb281f1ddf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ed2e71f080f76d0b993299eabf00956d8026d3b71ceae1b5f24f57c099bb20e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b482265be8c35b99d56e95aeefb841282973b4f4064a994ca347ee0560367bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c95bf7f3b7011ff70ce9368fceabae4f0506d65791ec5270dde9e166ee8759a"
    sha256 cellar: :any_skip_relocation, ventura:       "c51ceb4edd8b3120325ccf9e998f41bebd599584ae29c3ae80c61d65830d9dc4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80877ef0197b99f8cbb072f944f8c0d252ee4f63a6fcf50726f8cf118eef9b28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4174c57cd1ef4f16398f92d8dd944bcbb5f42c262fda36a092fa09e59b43e510"
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

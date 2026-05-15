class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/4.1.0.tar.gz"
  sha256 "bc3db8950f14d8a398382054212bbaad2f850d45f79eaf6fa582055ffd3e02af"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80f9a5b8089eb91b6e1c7a9c1de12f3b07bd020900554f8b82bd87e174cd8357"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d419940c7a227d188bb6121656b03faa8e4ccf768486c0ca612aac7e86f1ffd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6b71b3e961a2d4a2941091f7a5eec66191afae5b9a2df8b3df053f5179c779b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3daa60224a3ea34291975b6f980d969946318d3a9f224513f263be7673ada86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6afe6d298df18f338bf1f4cfab2f375b0199c5c50cc52ebe6b27332ff705579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58f43438ba8402a9effdf5819494e63194a5f2ed8797d87d8bcffd0b7a03a460"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end

class Skani < Formula
  desc "Fast, robust ANI and aligned fraction for (metagenomic) genomes and contigs"
  homepage "https://github.com/bluenote-1577/skani"
  url "https://github.com/bluenote-1577/skani/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "494b64ec764be1ad485cd5d4f8c97180ff61377863d990532f6fa9541ab1b6f4"
  license "MIT"
  head "https://github.com/bluenote-1577/skani.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3546fc60dc5365b882e38900e4d073a448d0807017a361850b2431e14d4fa2ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e82c68ed88fa2a1f79205d801e065f75d7e1be579110f643a233036910561db3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aac2ae00d83aa56517fce2357e1ed32acb4d479f13ae10680e004a8414ba091a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e916617176a333e48a633f62711fd64981759db8c7ab90130ce879f925126c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b45a01a56e17d9956fa8dcf3759eb38cc64ca85a5e8d653301b4e05452dd4a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920c90c25b0714d398f7840d2004ca2ef26f7071f7d47a72e88784fe949bc207"
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

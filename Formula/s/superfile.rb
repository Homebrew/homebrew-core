class Superfile < Formula
  desc "Modern and pretty fancy file manager for the terminal"
  homepage "https://github.com/yorukot/superfile"
  url "https://github.com/yorukot/superfile/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "38ecb89048b712d244246c7317115d973c1b56323295e902fbe7e2cc400d9cd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49fd082e2892c91bccc6071d8469092c9af84afcee7624996d1af56201227d1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c092d10844ccb382fbd929c73f1eb64c8c737d60f88235e423e0e1ae04f03f00"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b5dcf1e2eb1502f36d09d8ab9f5e4aaa7c1830f2ad4f917ec541e4bbc82aed7b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c7ce7ac07f2795bafadb66473c39e04412e4ffde166f13dcfb7d2f4678451c2"
    sha256 cellar: :any_skip_relocation, ventura:       "98a45a4aa25f82bae99d39cd47627341c83f3fc71ab00f4c68e5d43c049d6bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f600b994ed2ec0e146046e8c6b02db19fc5c79bf09a8b83465105eeb35fc52e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"spf")
  end

  test do
    # superfile is a GUI application
    assert_match version.to_s, shell_output("#{bin}/spf -v")
  end
end

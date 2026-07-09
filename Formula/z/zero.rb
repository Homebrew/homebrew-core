class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://github.com/Gitlawb/zero/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3d6c1db2e780205678e3e8d815a09fb77bcc886828b3e0c529d6ca4e8bac3589"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6456fcb451d67b07727128bc006238a7e29ad967180e65e01a2024e63d67a5b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3adfcdce249d8968dec3ab9a5f575cb332ef19e13ba2863523354e18d4aaf543"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9b3945225ce439c3b7f9382a35d288a20561ae099236d1ecdd7248a82c376ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bba05093462d80440245f63b868af2f083e582e577e0bc2056c05e29af9ee2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c7b092710f817993291cea4dc5810b346c1eaa29f0e47c406a4b4cd07c18c314"
    sha256 cellar: :any,                 x86_64_linux:  "c0e7423ba4cf86c812603a15c08ff252e931587b24d5eb8e5d09636452930d68"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Gitlawb/zero/internal/cli.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/zero"
  end

  test do
    (testpath/"cmd").mkpath
    (testpath/"cmd/main.go").write <<~GO
      package main

      func main() {}
    GO

    assert_match version.to_s, shell_output("#{bin}/zero --version")

    output = shell_output("#{bin}/zero repo-map --max-files 3 --max-depth 2")
    assert_match "Repo map", output
    assert_match "cmd/main.go", output
  end
end

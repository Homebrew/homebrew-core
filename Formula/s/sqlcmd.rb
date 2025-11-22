class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "c11ff96b6c31314f258a7a58e52e525c525452865591a581c98a37f6c0a7df60"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a34ea026882eb3c78f605dcb1fd496f8daa29da0bba42a54f7f3aafdb68a9cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a34ea026882eb3c78f605dcb1fd496f8daa29da0bba42a54f7f3aafdb68a9cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a34ea026882eb3c78f605dcb1fd496f8daa29da0bba42a54f7f3aafdb68a9cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f65631314958538547f8caf001c295154ab99b8b31a61c1ac1846094b07d57f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "043ffd7a779436b3008bde8ffac5f3d5cebfe966dbcc336438262547a0ca5c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "129f6709d9f3a1cb601282a5e132470da24cc3341c54bfe918bdd10cad6ade4e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end

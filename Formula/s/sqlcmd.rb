class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.8.2.tar.gz"
  sha256 "ee600e4a147fd1e3c5e6cea834f14465fbccbd96f6b32bd3b4c9e104e094b9b2"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45e392b83c68e7c458be9191b188528a44e0355490d202a0b4eff439265d3447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45e392b83c68e7c458be9191b188528a44e0355490d202a0b4eff439265d3447"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45e392b83c68e7c458be9191b188528a44e0355490d202a0b4eff439265d3447"
    sha256 cellar: :any_skip_relocation, sonoma:        "4a58834b43e3a4664d9bdf1a1769423a77baf80cf291a1eb4f03e34e873a10f7"
    sha256 cellar: :any_skip_relocation, ventura:       "4a58834b43e3a4664d9bdf1a1769423a77baf80cf291a1eb4f03e34e873a10f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ef548bfb7826d3a14f44d314943c4e25df4b16b57897906f4a12e7690194a31"
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

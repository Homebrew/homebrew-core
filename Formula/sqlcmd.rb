class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "39a964ffaec8004cb6b8b6cd5abdf46bbbfb2c03bf608bf0988cb8b5e17bf5ce"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7c45117c9deccfaa8e9ac2d067e04372555a4570f4afb458801b9a5364f04ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7c45117c9deccfaa8e9ac2d067e04372555a4570f4afb458801b9a5364f04ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7c45117c9deccfaa8e9ac2d067e04372555a4570f4afb458801b9a5364f04ab"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d39600324fcd65d3425e3850dc2e8d0e3b28a8327404db980199688bb681f5"
    sha256 cellar: :any_skip_relocation, monterey:       "f3d39600324fcd65d3425e3850dc2e8d0e3b28a8327404db980199688bb681f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3d39600324fcd65d3425e3850dc2e8d0e3b28a8327404db980199688bb681f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87f1042cc320635fbe7ca03ed4c3046e051ffa607f7b75721f68e0a038b39825"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end

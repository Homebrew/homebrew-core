class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a9bf7a99a9e22bf0e59bf282e011f9213455438869c9e1847a1c23a75cda0517"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9093f0a7a21d0c3e4edb3bde1519e105bfadf65eb9028f11e2dc60a086839944"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a28e1ba6104a88e0a47d234d1cbaa94ec671fb214c06e963098af4f7d6d87f88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b61389e3834279aa2a513a515f73e21404c87e6560acef1004f3c77a018f27ce"
    sha256 cellar: :any_skip_relocation, sonoma:         "0fc2d64ab3ea95dfa9c61db97387ae8697a81d1e29cc1df0ae561a206fcfa3f3"
    sha256 cellar: :any_skip_relocation, ventura:        "7cb4b819a3616c4eb7b2565555df559b7c3b5569e0d5eec0eab66075fd5affeb"
    sha256 cellar: :any_skip_relocation, monterey:       "e324f5d07e0bb5ff81e5ddf854068b1c4b37cc4f2afb78985156d60168c4af63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0051bc5da092ed140d4fc2906cf5144b9fa150bdd8cc0c93a02e2c6eff338665"
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

class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "c9ab499a5177a57b1464234b795ca704d00b384486cc4e34c2cfdac12d072374"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ca8c13d4ff8fee4d6e270017abe8e062966a37815994634a82ab1a7237f4d099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb0f7a97c9de585144516a1d0eec4b5355fd08a0a665d62e31324cc964e2a63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9a357a1c8c8fdbc0ba87753481cf1596587676095245f16a8a59f3a0635085b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c4845c438031d490fbecdd99873c9d1acdf46effbc17e371ba2935cfe543e3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "20b5e85b7ee1684cb498b9a7dcdebc21d8ddeea098e026ee648324c8e95bafca"
    sha256 cellar: :any_skip_relocation, ventura:        "94a5be641140ea52ad138a24c020d0ba4d543495d2dead1140de4d0cac6cb3e1"
    sha256 cellar: :any_skip_relocation, monterey:       "ba6392afc75363b2e75f95361ea67bc599f827d69a5e4f8e03d3ab4176f1d4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a86b88df2d9462fb934e218f6830e756462e9f69eb17e286069cfe2245c71d77"
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

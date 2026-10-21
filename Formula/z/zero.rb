class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://github.com/Gitlawb/zero/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d253f69beb00cbc0fb23a302914caf960e2a1d94b045778ff2ed2671fab35f50"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8f96eb9fd9027489281842f9fffe2449c7d9c5f83d6c66bb4ebdf5ef492edc3a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8f96eb9fd9027489281842f9fffe2449c7d9c5f83d6c66bb4ebdf5ef492edc3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f96eb9fd9027489281842f9fffe2449c7d9c5f83d6c66bb4ebdf5ef492edc3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "52bb69d4329517574f9019acc625f688bdf2639d7b2ade98cda2ba34e495df5e"
    sha256 cellar: :any,                 x86_64_linux:      "5fa78034475928156980de4fd20e469a9c128c0047d3bccbefca9148af09a114"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Gitlawb/zero/internal/cli.version=#{version}]
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

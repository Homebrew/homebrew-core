class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.gitlawb.com/"
  url "https://github.com/Gitlawb/zero/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "9f8ec37478f13d6e72b90b85f87ae586a8dea1debd94d035e8dce22eb67a1fa1"
  license "MIT"
  head "https://github.com/Gitlawb/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c813340e91edd724a9abe7054e8d5b02a0612988be95d5c2173be0d20ea91c25"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c813340e91edd724a9abe7054e8d5b02a0612988be95d5c2173be0d20ea91c25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c813340e91edd724a9abe7054e8d5b02a0612988be95d5c2173be0d20ea91c25"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "efeff823c809818f5bc96c41f4e1bb60d1effb895fb2aec4d2040283ac98ec7e"
    sha256 cellar: :any,                 x86_64_linux:      "a5f69045c131c71f4b1a65068b92f0a720a36d2f795c75c76a8e90c93747cad3"
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

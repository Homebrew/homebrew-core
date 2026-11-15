class Zero < Formula
  desc "Terminal coding agent you own"
  homepage "https://zero.twigpine.com/"
  url "https://github.com/Twigpine/zero/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6b826c0189e117c6ae4b8adfd1199fa41bf2e3a14c1d030ead18d82e22c20b65"
  license "MIT"
  head "https://github.com/Twigpine/zero.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6565a0044dff0eea1ea7515ecd0acee35d4adb452cfc83dd169fdd05c627a78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6565a0044dff0eea1ea7515ecd0acee35d4adb452cfc83dd169fdd05c627a78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6565a0044dff0eea1ea7515ecd0acee35d4adb452cfc83dd169fdd05c627a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7189633d1a509e5b1ab9e77ff4ce744d6453ee80d950f97db708642641a51df7"
    sha256 cellar: :any,                 x86_64_linux:      "8c1f3050030ba236309d6bd0f13daec5264b0bce36733c6275cf9de63794e299"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Twigpine/zero/internal/cli.version=#{version}]
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

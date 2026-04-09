class Scmpuff < Formula
  desc "Adds numbered shortcuts for common git commands"
  homepage "https://mroth.github.io/scmpuff/"
  url "https://github.com/mroth/scmpuff/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "6a889718563dd3fbcccb49684acb628a9d3edb1f0e00dcb66502e2ee76c69f60"
  license "MIT"
  head "https://github.com/mroth/scmpuff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d061291901d6dc2590b41057db86ac0df085bac9d0e2c2b070338842e8cecd0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d061291901d6dc2590b41057db86ac0df085bac9d0e2c2b070338842e8cecd0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d061291901d6dc2590b41057db86ac0df085bac9d0e2c2b070338842e8cecd0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "42790a15d7d8d2cd061e50259c72f3519ecb9399e006cd5a9f010b527f1f934e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e4a90f2c030af2626d5783003364c3fb19758368cb2aeaf006674265d756b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d40c99d18f64198dbb270be8f38bc1b9594c59263d49e283ecbb3269b0fe6066"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scmpuff --version 2>&1")

    ENV["e1"] = "abc"
    assert_equal "abc", shell_output("#{bin}/scmpuff expand 1").strip
  end
end

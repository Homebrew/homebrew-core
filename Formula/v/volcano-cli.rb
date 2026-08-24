class VolcanoCli < Formula
  desc "CLI for Volcano, Cloud Native Batch System"
  homepage "https://volcano.sh"
  url "https://github.com/volcano-sh/volcano/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "03f265f27db31f5d0411ecbf4969175251f1293b0a426d58cd06450500c7ffba"
  license "Apache-2.0"
  head "https://github.com/volcano-sh/volcano.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d10c20775c856439fab90cc04f0c2d7e58a11b746a068591d149420144f2333"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8d87232b1d6212ab3ad2901ac2f5b3ec274dd26ff74db6921e490b8bc5dde0b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "114449fb7be58537949e6baba1df3b4fedf8d22c10ba0bac37db59f631b90707"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9ee08bcab4e2882f3edb370c087c55a1995fc375a38fe0e566ec9f0b929c5b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06a3387553b7296267d57de589ce469e99312803c0b27fd8aa905dee8ad7cb28"
    sha256 cellar: :any,                 x86_64_linux:  "a05d58836b3df6e92f77bf02156c4c94de38ef51e8af44263fd7da71b6172e3f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X volcano.sh/volcano/pkg/version.GitSHA=#{tap.user}
      -X volcano.sh/volcano/pkg/version.Built=#{time.iso8601}
      -X volcano.sh/volcano/pkg/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"vcctl"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vcctl version")

    output = shell_output("#{bin}/vcctl queue list 2>&1", 255)
    assert_match "Failed to list queue", output
  end
end

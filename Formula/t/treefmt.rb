class Treefmt < Formula
  desc "One CLI to format the code tree"
  homepage "https://treefmt.com/latest/"
  url "https://github.com/numtide/treefmt/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "d4000dfcdbabc9caf356005b38e18a6de71f626327d02ba609beec5846931f24"
  license "MIT"
  head "https://github.com/numtide/treefmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "902f91f69a81425e7607a13e28defc1c21bd42ced20cb8e410d203f89d69c900"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "902f91f69a81425e7607a13e28defc1c21bd42ced20cb8e410d203f89d69c900"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "902f91f69a81425e7607a13e28defc1c21bd42ced20cb8e410d203f89d69c900"
    sha256 cellar: :any_skip_relocation, sonoma:        "468311bb66fdcb624956b1eaccc7182c4f27de53e6b68598c034ef61143bde58"
    sha256 cellar: :any_skip_relocation, ventura:       "468311bb66fdcb624956b1eaccc7182c4f27de53e6b68598c034ef61143bde58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d47ac8b63bd2700fec7f21e022e274c092e8b8017341e22fb89b750313145428"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/numtide/treefmt/v2/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/treefmt 2>&1", 1)
    assert_match "failed to find treefmt config file: could not find [treefmt.toml .treefmt.toml]", output
    assert_match version.to_s, shell_output("#{bin}/treefmt --version")
  end
end

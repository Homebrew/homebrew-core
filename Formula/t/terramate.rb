class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://terramate.io/docs/"
  url "https://github.com/terramate-io/terramate/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "f7d002121cffdedd9191d1ab5bfc15fa8bf5897acf8f520de0d9e45d1cf2131b"
  license "MPL-2.0"
  head "https://github.com/terramate-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc38824bb637806ce8e126ed51ac1309fd24d6807e113d782d328a2fa1c53f40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc38824bb637806ce8e126ed51ac1309fd24d6807e113d782d328a2fa1c53f40"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc38824bb637806ce8e126ed51ac1309fd24d6807e113d782d328a2fa1c53f40"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8302d29b395e68385f61e4a89ecf5c607f81068b75f127b57d5a9c772d2a202"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e113555664fa3a8bbbd32468480bd0a56019f43a3803da6a0cf8dfea1cab029"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3efb29aaaf454238c77ae74be002bbbeed33f7a83ecd0374a7d862cffd97cf1a"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terramate binary"

  def install
    system "go", "build", *std_go_args(output: bin/"terramate", ldflags: "-s -w"), "./cmd/terramate"
    system "go", "build", *std_go_args(output: bin/"terramate-ls", ldflags: "-s -w"), "./cmd/terramate-ls"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terramate version")
    assert_match version.to_s, shell_output("#{bin}/terramate-ls -version")
  end
end

class Swctl < Formula
  desc "Apache SkyWalking CLI (Command-line Interface)"
  homepage "https://skywalking.apache.org/"
  url "https://github.com/apache/skywalking-cli/archive/refs/tags/0.16.0.tar.gz"
  sha256 "712a4f484121b518abde7f98a2a0cc4cc4d03ce0e28f59636376630c8a2aabc1"
  license "Apache-2.0"
  head "https://github.com/apache/skywalking-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6d025e483d0218e3321a43867f0236a69eb2ed408b4ad60050f6430fc5224ef7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a902147d5ed5fe7009b2bd2dbb6fd683aef52dd1b5e02bab6fd70a6773db7f7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e67fd627a8e2f5b996beffdd3dfb693a2fa004557faa69030b4dc4cc4c7e4aac"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c4774ac8e53bc19c9b7b5904416b2f587a660efb9459afa62e5ee0f5931ea8a6"
    sha256 cellar: :any,                 x86_64_linux:      "021e439ac12adf237c5573265a976b769e5a69531fe8e46dfbdc3d6b8e64359e"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/swctl"

    generate_completions_from_executable(bin/"swctl", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/swctl --version 2>&1")

    output = shell_output("#{bin}/swctl --display yaml service ls 2>&1", 1)
    assert_match "level=fatal msg=\"Post \\\"http://127.0.0.1:12800/graphql\\\"", output
  end
end

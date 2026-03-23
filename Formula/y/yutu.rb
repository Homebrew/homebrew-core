class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "fbbb870bbf5708598b8e4cbba020b5f6898bd972a719aa27ee8cc4d876af41ad"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3b5e8b70c3ec1fa226913cf5965077d8be5cb753331a8af505816fcdda3b955b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3b5e8b70c3ec1fa226913cf5965077d8be5cb753331a8af505816fcdda3b955b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b5e8b70c3ec1fa226913cf5965077d8be5cb753331a8af505816fcdda3b955b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a429ffe40db462eec7b475c0b62e424f69b2149f0603f33e08fc0d6cd7a29f27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "343969f6301f743b73c23d0dbea8ce9949e62a848e409a77dc19ab37786caa04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "205f43f3037a8107b528e93fc1eb9a20f2a15035c1f03835fcd5c16df27f5cfe"
  end

  depends_on "go" => :build

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
      -s -w
      -X #{mod}.Os=#{OS.mac? ? "darwin" : "linux"}
      -X #{mod}.Arch=#{Hardware::CPU.arch}
      -X #{mod}.Version=v#{version}
      -X #{mod}.CommitDate=#{time.iso8601}
      -X #{mod}.Builder=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"yutu", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yutu version 2>&1")

    assert_match "failed to parse client secret", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end

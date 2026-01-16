class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.4.tar.gz"
  sha256 "7d0b4f69b75119f619cdbb4fe565a7c22c0b178de5d2a132fbe05ad80d3ccc14"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1477d1f88d423ed9deca2dd76dbbb2b259757818822a08b4d0ff1d86a6689a93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1477d1f88d423ed9deca2dd76dbbb2b259757818822a08b4d0ff1d86a6689a93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1477d1f88d423ed9deca2dd76dbbb2b259757818822a08b4d0ff1d86a6689a93"
    sha256 cellar: :any_skip_relocation, sonoma:        "08074111931e8fb7cc8e16a58a9f6eef91af13c02e69f12cc2f58b64408490f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe30adec402612d7536fd90cd3e6d922e86d3c1d837f2271387f202146dc198a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b49e6b9de9d3bb5248fc0f1c4438fe6f21de0a4a0c59f297132faf9db8887844"
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

class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "b79912ef164c2f760fa14ecd815265b8bd6a95edc8fdb17f50a180d7737c2b5e"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fe246e32e9fab9d4db2df5b3bc0c081767b4698632a182ecbc7597acc7bdc00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fe246e32e9fab9d4db2df5b3bc0c081767b4698632a182ecbc7597acc7bdc00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fe246e32e9fab9d4db2df5b3bc0c081767b4698632a182ecbc7597acc7bdc00"
    sha256 cellar: :any_skip_relocation, sonoma:        "1634f33dc53d49702e0c6be8b20956a1230b20cbdd50ed1988a509ee0210cac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b14b9b88467695f864a49bdbc969dde4be9a6f6907824ab54ec8e462dfc3accb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b59f17f68ca0072f52f1d5e56f94608d698bbe784065f40260827ad56eb1a030"
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

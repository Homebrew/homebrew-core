class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.8.tar.gz"
  sha256 "c6b8074ad28f8416f97e027502e261f8d6a7796da3e72886822830576138087d"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c545dc4c3b262f641dad584a7e89c1c7f850d0cab360d1409b1f0e04a5a7ea2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c545dc4c3b262f641dad584a7e89c1c7f850d0cab360d1409b1f0e04a5a7ea2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c545dc4c3b262f641dad584a7e89c1c7f850d0cab360d1409b1f0e04a5a7ea2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "a97054e668c2bc5669f89ee0ba1c6fbc1d2667af3ee5a592027b744800686f88"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b4a642c3dbabe9fcc2871685aaab9c5a2e12b2bb1025d2a14dc200f6ddcf8d33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5ca5eec04e41f45122fcf6376aed04aa5f7373729d7c3aa78e9c1013100e55"
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

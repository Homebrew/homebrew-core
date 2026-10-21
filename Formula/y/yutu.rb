class Yutu < Formula
  desc "CLI, MCP server, and AI agent to automate YouTube workflows"
  homepage "https://yutu.ifor.dev"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "456affd706e72cdcc96c23bc3394b9011b9c1c2564054a155c081b70d05fcfb5"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "78d61be41f5335b50a823a049d2347ab9bee7b2247eb08c39b168e20188da1ce"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "78d61be41f5335b50a823a049d2347ab9bee7b2247eb08c39b168e20188da1ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "78d61be41f5335b50a823a049d2347ab9bee7b2247eb08c39b168e20188da1ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cf58cc05c88a05f96febfed3f9c9b7b3b986812ba05ef7eefb3bf9d907bdf1ff"
    sha256 cellar: :any,                 x86_64_linux:      "49c018715fe87054bb7fc2426e5bb643df0430bda53164cd8a90a8154e93de20"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    mod = "github.com/eat-pray-ai/yutu/cmd"
    ldflags = %W[
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

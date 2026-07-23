class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://yutu.ifor.dev"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.9.tar.gz"
  sha256 "4d5481ce801f5747e5e518ad750d22eba2235d93627ddd2934d6f1c660b86bbc"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eec556beb0e41023da08321e2f9bf39e759e68d24ec239787cda8b7038312113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eec556beb0e41023da08321e2f9bf39e759e68d24ec239787cda8b7038312113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec556beb0e41023da08321e2f9bf39e759e68d24ec239787cda8b7038312113"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9d957e0fa54defd89c0b491c4a9cbffdd595b902d502dc51f334f1dd663507c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b921b4a852e58b9885cc9ceeedff4e6b381ea725d2713e6d35a1723597dbf104"
    sha256 cellar: :any,                 x86_64_linux:  "9a07d931f70c81374a226ea206c9ea4eaafbfc2801a36775d2430c9f31b34664"
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

class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "00c4ee6850705ae4557733580d9ebbd9f378a28eb39f3a261fb5df10e8764423"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d33cf0182cf6ff04a769a81a44bb0945a1dd624411e7481602effd6b70020db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d33cf0182cf6ff04a769a81a44bb0945a1dd624411e7481602effd6b70020db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d33cf0182cf6ff04a769a81a44bb0945a1dd624411e7481602effd6b70020db"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd3c7e56880e904d1837b2ce878f7282f0a7a8fc1b665bcc25ba636ade375eb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fd8a1d662ef8836fc99240dddab3edb5955719ec36d9465dc9432819454dffc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e5c22981d232278c70dc658e0c12218ae1e20482c7cb6cdfc5177b50078564"
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

    generate_completions_from_executable(bin/"yutu", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yutu version 2>&1")

    assert_match "failed to parse client secret", shell_output("#{bin}/yutu auth 2>&1", 1)
  end
end

class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://yutu.ifor.dev"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.10.tar.gz"
  sha256 "1439e051f13b3471000400b714ee801170b68f255806c88fad1b7183dbe39ab7"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddb1afe46737ba670b26805c4afd8505f3600c3d6b27fd49a8e7be8aa60c396"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ddb1afe46737ba670b26805c4afd8505f3600c3d6b27fd49a8e7be8aa60c396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ddb1afe46737ba670b26805c4afd8505f3600c3d6b27fd49a8e7be8aa60c396"
    sha256 cellar: :any_skip_relocation, sonoma:        "868d1f8e98742806562bb84944388c6ac700cf34f0886ffe4ac6d87d5c7f3cd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "894921a3f1ad13c2fc2a7bec7e629401bf7788a9181c9c35842e6fe48f9ea73a"
    sha256 cellar: :any,                 x86_64_linux:  "ff2e4da54a3047ebc885ad732c9ca9bd6db501b6b3572f99fc4997b8d24a6876"
  end

  depends_on "go" => :build

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

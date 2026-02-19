class Yutu < Formula
  desc "MCP server and CLI for YouTube"
  homepage "https://github.com/eat-pray-ai/yutu"
  url "https://github.com/eat-pray-ai/yutu/archive/refs/tags/v0.10.5.tar.gz"
  sha256 "c7ac15310a94583ffb8b499c03f88a23eaaf1f3bf183dd522ecbf4b6537299dc"
  license "Apache-2.0"
  head "https://github.com/eat-pray-ai/yutu.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "820c1390195b6f8f750580caf516393588d4479a79418316b73c25006e9fcf41"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "820c1390195b6f8f750580caf516393588d4479a79418316b73c25006e9fcf41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "820c1390195b6f8f750580caf516393588d4479a79418316b73c25006e9fcf41"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df0209db749c58589349db54fac90e5b8dda1c6b08c42628c93cee6dd9706d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef736d678702ba1ff0efbfd35b976ff59cd12888b77269554f5c316246b396a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fabda05f164aac34a1efe6d3310ad9817b1265290c6b421472d29e8b09708f31"
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

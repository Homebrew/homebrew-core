class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.86.tar.gz"
  sha256 "8f2c87e9423a1e4e71b834b680430e95ecdc0bb4e7208aabd2389209820a402a"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c17209cd9e340595b6c7a5654b57020614f0a19efa0f10d4a4a7767afa9e837e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1dd1d3b7ec896758c85f82f97208ca088e464faf4ec64f3f40ac496c8667c213"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0965399e241145859c954eb611c82d445c33dfcc4044570860ddf7d06b68587d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6594e261dbd9ec5a8b879db6965e1edbe53cc37852d4cdab37b35bc95bda4145"
    sha256 cellar: :any,                 x86_64_linux:      "4a4ec9fd328c3a50ed6cd8f99fbbcb85e33b4600a2688ecbef053edce65d8c8d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -X main.redressVersion=#{version}
      -X main.goreVersion=#{gore_version}
      -X main.compilerVersion=#{Formula["go"].version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"redress", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Version:  #{version}", shell_output("#{bin}/redress version")

    test_bin_path = bin/"redress"
    output = shell_output("#{bin}/redress info '#{test_bin_path}'")
    assert_match "Build ID", output
  end
end

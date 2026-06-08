class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.70.tar.gz"
  sha256 "a07a4ae05352e9696f9191fb05a6b9e67107d5d812d489969b99ddf9cda44aa8"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb6b82d6170d8572673aaa20618ba58961c87421aad118befa0a3afd0c70e987"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7ccd01ea9750690f28ddd6f4d6e3dd2c1068235b5b2cc8f4ffab53ce9264e4b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44944df75b527ccafff4b87b6f20f3e6e6330335507c86f38a1f73b637b9522d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2d60c7ab3b09a2af4873266c8e9222aa7f0276bb572034a3d44398b1a5b9eb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f096dd9f2e8e53077cfae17213608482d7faf792d31e7ffe19087d99abcb9a8a"
    sha256 cellar: :any,                 x86_64_linux:  "cb6b7cf8261c9f6154730029c47521456540e406f8f2f18919bfee9630199409"
  end

  depends_on "go" => :build

  def install
    # https://github.com/goretk/redress/blob/develop/Makefile#L11-L14
    gore_version = File.read(buildpath/"go.mod").scan(%r{goretk/gore v(\S+)}).flatten.first

    ldflags = %W[
      -s -w
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

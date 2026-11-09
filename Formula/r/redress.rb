class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.100.tar.gz"
  sha256 "adb6c010280178dafa64d3baaa0f58fee84b74ffafe4a8a0cc787f2200beaeee"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "26a709b11321d1b9fab46fa5f7e5013c7be9c9350a95c9d440cca0ed2a4aa1c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a610476254aba8d8b399cd7eda2e3fa7b56f9dc5209a69c5a6318152a0bdd3a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "707a41acaf7d333c672cb4bfa4d993939382935105fb97c8fca12171c15f787a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc7fd939e46a5c25f6d74f0ae03aad498169930dbf2c29f4943ca41fe90d1363"
    sha256 cellar: :any,                 x86_64_linux:      "8846e663afbf859979579af9e5ef8febbb87f1ff64337f8d42e6f4e19b6c58cb"
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

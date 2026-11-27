class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.103.tar.gz"
  sha256 "a66566344f2e32694ea4406f42abadb2d02a43ed5341d1609602c709b49e0df0"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "55738e0bb762434a45c6609e5d5fd6b1d6238b5fd4de419a73dd9e1e81d1f9cc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8d30142775038e09d8fbf3a68838e125e327479efb7636ff7b4a0e9740bbc808"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "70aa7535c7101e6abb1562580ab46926c56d8c3c6a155358882ab8f7c69df6fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e9538f27b67f5d823eeafe6ad313a04ee9ec522adda1d219e2fb016d38b0a6eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d175b08a39d2ae986565605e514b25ba61657817f729256b959928aec75d7b26"
    sha256 cellar: :any,                 x86_64_linux:      "10666230cdcb64e035507d63e1bf9e48e7ea2249ed76b951644021bf21276a17"
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

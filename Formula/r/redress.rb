class Redress < Formula
  desc "Tool for analyzing stripped Go binaries compiled with the Go compiler"
  homepage "https://github.com/goretk/redress"
  url "https://github.com/goretk/redress/archive/refs/tags/v1.2.101.tar.gz"
  sha256 "e0a8e7e1e67df29858de30e79733d2280a2963add43e40940f109261c7b46cc0"
  license "AGPL-3.0-only"
  head "https://github.com/goretk/redress.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d81acd0b139b3519a89ac80d5f91f76e947d9dfe0fca7a3508d0bbada1e3b5dd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4cb63cfb7ce7a7a82b1d352737e43c4d4e68625520eff416f0d19c5e79085eab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5dcbb97a1a131d26cd2b38d73a77fcd8207056b13e15aafb0b41fae17e27421b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bab0585d60e6c20a89a6896eef38705f1a55000f8808c61327d4c20e1681e232"
    sha256 cellar: :any,                 x86_64_linux:      "1d3c047791415a13a459949de673d01d864f73f4deff3d120dc8941647f48444"
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

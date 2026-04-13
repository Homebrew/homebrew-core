class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.16.2.tar.gz"
  sha256 "187f0c05f118f2d2476c5331e3cac191da1b57c7fc6046a05b0afa434d29ecb9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13edf520e6a37f41550ecd02230c38982b503879838da4108865b80c16c6b64d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c8edb2374c784c86d4b87de19db2f15f0707469d73ca424af7a80a4263e19f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "14f341869aad606b9bebe2c3a6b62af76618207f8694ceb4932b724d8206fb95"
    sha256 cellar: :any_skip_relocation, sonoma:        "60b80e2c2b09388641b0b6609a1492fac42b8ad295332baa9d29d0018dd7ae0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9d3a313ad8ba1d3cb4e5c605d212c12f215b0ecfbc9beae16de0fd4a9521e4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5a64de2a6dccae5903257716f2cd01cb698e7c650a1c58c56c2e1786342f36b"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end

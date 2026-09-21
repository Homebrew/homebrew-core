class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "529c9d663e8b21250e3e7da5708327f8c7b927621734f09004ba74387709bf1d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5ed647425e864ceccd02270bc63e444705159c996351b878b5f0e4141d48ef40"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8e4a1b09af2e8b1924e010843a68ce2637c9a91f92069aa0dac71b71a18742c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5365a895868adbfe55dbab1c3204e66f2abe73b842e16ea279634bace1daaef0"
    sha256 cellar: :any,                 arm64_linux:       "e2ae746b61436043de660e1a201e322f24cfb0c2d9c1063d05b1930b633f4d20"
    sha256 cellar: :any,                 x86_64_linux:      "f446b8825b39d3592237ba7d8b15865ebb9555c38fabc694b3b9f1d26bc2c277"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end

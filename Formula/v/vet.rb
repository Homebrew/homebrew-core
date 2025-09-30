class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.6.tar.gz"
  sha256 "d1a21d8f2ca1b6bdf1e582d1d9a2971605162f3f4a5ac241d60707b0eecf0e23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3bd99804be3c8797cfcac78ef06a9c91551ca74e9f7e363042e735197cbf47b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3b95f825d11a55bd5553347f9bb35885e4aae84d722e127c91f734e0fbd7ef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d793ff6b217ebcca4a2ca0b2451eb339250ebdacd29ce86537d39bd8ecdde9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a74103dcf34262220f42e1f8948da9d860f90284888a66debf8c6775d4ecb9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ccbd6b07e20516e110432769debead6d650f573fb311ff9bdf86ed2090f7664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c614c4c1d5ab0fe67f434bc852acc73e5e7d75d0f1b45f9ec761f81475b3284"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end

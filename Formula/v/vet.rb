class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "b0d5dd5a62fb32b279f7f0076ae6a49542085ea118f061c6ae430828d285669e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eabdce97d4fce2168d0fc7440361726bc1a5b50c0a5134a1df21ec8ef35da66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d63c9fa505f128c5f1e8d30e7601c9868c693f6888c7c336618c6faa65c57af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0193321f2fa2a2543bfd7bd44c75dd6da50d1cb89c9d992b539c37c4c2fa277c"
    sha256 cellar: :any_skip_relocation, sonoma:        "67467fe9b1168a3dc0aa3dfa6cf45b27bab888d65723cb14c595183323f7b742"
    sha256 cellar: :any_skip_relocation, ventura:       "951b5955eeda0550c5e0fde2ab2a807b84324ad789f6bb2f3c82b7cd7db6067e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cde1dac3dd48018cd3e789fdc790e2166111a061663f8a27e0ef44072a7b0b73"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.commit=#{tap.user}
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1", 1)

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end

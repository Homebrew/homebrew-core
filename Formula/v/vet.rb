class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "bf53ea353e117c45ac48c786a73f8d24b660c6a1db1e44083a434c66f1318bb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a36d4fc86e34b44fb4e839cf73d3f882446ab493c11bdfc4f130a7115c6eda57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1f8d02cf8b5e0e8830b1946d0982992e4a438c65cf3b48d9e9610fb22f4735"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89298f3bb6a7cfa9c8e3a0ba3b341dfd8a7cc22ac4c8092efebf85a6518b18b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8918b148f29f7efbf6153b09bf01574b41564344f3b31daa7552f00fa55f36d"
    sha256 cellar: :any,                 arm64_linux:   "047e6a67e390354f2522c91b3e51ec152689f04ae7c6ed6f9da240fb6579717b"
    sha256 cellar: :any,                 x86_64_linux:  "8f24c66205f6d3a0d65f5dd473fe86c31611b4942e7e0cf6103c84ac7df18f2d"
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

class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "9ed03582f4eedc97e5442ba1dd0d575cab2cc1fca6b6bb2da043b79f02fb74e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f62ad3311999649709c9d0fac43b88a6e9d630d81e61faa41ac63e1095f275bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2f5597477ce6038743b252f3d6d35be4cf6ac47268d7d066df551cd532319ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "333f778fb4b726b2596ede88b39801669455521a9e6bb1591e32811ad75efa9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dbf0521dfbd46bc37174eebc0e6f2b56a0d6376d8d2e3e6dbfe5a7e13c385e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f823c0b1e2fee8529f479f1f0be33c22de60d8df24f91e5c9a668ae9723daa98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de1536a0b34c5a8d0a1ee1e8399e9aeb614f0ac08b3d70f400f6c27f15fa6e3c"
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

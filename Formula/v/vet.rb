class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.16.tar.gz"
  sha256 "8e39b4d39957f40b47c233bfa1558591779888427dad37c7a9391f08707672b7"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a45b1d04276f70ae216d9d8fff8c1466ee829de5faef6673b9b6eb939b45e45b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5308cf52570c93b09e08e4419a44ed91259f7dcafdf9dda96e3eec23956b209f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db348b6e06a071d28701fc6b3e7270d19e55ddbe33707bc0806cb7e73eacf4b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "27a6a215a21f59d1abfe9b70f5f60d1874e0ac134189a10d6cccb77868a39d3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e34bd97681bef8ed0a1c2852fd2e81fc070336025a430114fb3f061baf19881"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bab2fa5778263e20120f4e474e34d8d93b02ccedac66fa8ef5915b61957bdb71"
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

class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.7.7.tar.gz"
  sha256 "8fef335a930a1c752465e871125d269a72df4f39b6cec65ca6531383faba4f9c"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b6f1b521cb68a3f2e8cf8b49870bc59809ec2b2867e452a0ed543ef363b8b84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b6f1b521cb68a3f2e8cf8b49870bc59809ec2b2867e452a0ed543ef363b8b84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b6f1b521cb68a3f2e8cf8b49870bc59809ec2b2867e452a0ed543ef363b8b84"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6bb4111796e3188afafc1fe6ccfb228ea2785e303ebd1c33e05c328f0b351b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4e9602d3d116d9bddbcb59cce28750d77e61e074a583e4b5d20c8a493d76f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2d31424624def0cd846b75aac551a52149a8b3119ad0d863c456c9923204be"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end

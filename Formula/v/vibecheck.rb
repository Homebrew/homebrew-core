class Vibecheck < Formula
  desc "AI-powered git commit assistant written in Go"
  homepage "https://github.com/rshdhere/vibecheck"
  url "https://github.com/rshdhere/vibecheck/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "86a54b1b4aa2a4aae87948c79f8553cb8965541fdf5911acae31119b172b3147"
  license "MIT"
  head "https://github.com/rshdhere/vibecheck.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d485a0a96e1a887e203ad9140c68af37f955060e312eb9c1b2d7227e95cc8456"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d485a0a96e1a887e203ad9140c68af37f955060e312eb9c1b2d7227e95cc8456"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d485a0a96e1a887e203ad9140c68af37f955060e312eb9c1b2d7227e95cc8456"
    sha256 cellar: :any_skip_relocation, sonoma:        "8895bd46f2937932fef5e9af2e8d2d4d92c960868f78339407e200402c6e88c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3dc92930bc2e88bfeb3a3e505dd79736b6eddacb708cb9344fa59bc2ce0a8739"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "057647db06103254a2a780216a739397b33a03b03f5069857bfcd210eccaea7a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/rshdhere/vibecheck/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vibecheck", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vibecheck --version")
    assert_match "vibecheck self-test OK", shell_output("#{bin}/vibecheck doctor")
  end
end

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.54.1.tar.gz"
  sha256 "e2c8b5cc5fcd95b0f1918f59700eaff99aa87b705ca4d16db4fb577a3907c24a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d799c0dd3a0654e9de56f7bd793ccf2440b2e57a0017c0b6b1c4a180f1f4adb0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d799c0dd3a0654e9de56f7bd793ccf2440b2e57a0017c0b6b1c4a180f1f4adb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d799c0dd3a0654e9de56f7bd793ccf2440b2e57a0017c0b6b1c4a180f1f4adb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d886649b5dc2cd0b1134e875d6f70a892cb3c6b6828914c018771a80a16bba95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2b6510264d646aafcf23e4fe225465587f2766265571b3aad6aefcbbf211bb8d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

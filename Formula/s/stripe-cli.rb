class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.51.0.tar.gz"
  sha256 "1fa6fbdddc7e84665bf48c172e73d2afd2ecd7cb0927d668bf19795d0b2b7c5a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68d04e814f0db56ac50d41b80b1dc6678866ac676edf2be883d9b15ad2117be6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "68d04e814f0db56ac50d41b80b1dc6678866ac676edf2be883d9b15ad2117be6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68d04e814f0db56ac50d41b80b1dc6678866ac676edf2be883d9b15ad2117be6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "991e46290b7cc1bf2d6257dc7893ccec935732921139ee1d394d75ce0fb701f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e32edcfc91ce8b34d4bd4d2aa6cb0e6b07d73c555b5ca9b5f1a6c58548b5dfca"
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

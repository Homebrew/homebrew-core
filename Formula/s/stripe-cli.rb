class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.11.tar.gz"
  sha256 "8c24a8d5e9033a1d063b035988ccb11ba5c0e1163ee5a4ad6207861b65da959d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "021ce5ff77b674cfb3d2068cc34876e1cfde3efde094f505ecd8adc9b37a4abd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "021ce5ff77b674cfb3d2068cc34876e1cfde3efde094f505ecd8adc9b37a4abd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "021ce5ff77b674cfb3d2068cc34876e1cfde3efde094f505ecd8adc9b37a4abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "241feecd1b4e039b79f43d60bd6d71fd8bcf68b2d0425217e93519e69780c0ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3979f51af323a0483552348601211bbad1b2f2ef96d19910c229d5d1ca7ae164"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "cd6bad3ccdae6d2b79ca61a9255cef83381683a7cfcdc2de08ad8e821cb71128"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "54a0aea03c7b9bc00696f96b57cf2b1a3a4ca946fce838ba2a9aba2ea7d63b13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03b3364cb8742e1f2b930b30056cf5550d911bd698d22026d05d59599a8c0b69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a205aeda494c88f2faf446e75daa54d4f92ed0be62c0fbe76b37da9eef6b6087"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f1b3b463a5ad122ffa663fe0a6f6d3a43722c39ed8bb846b22038b5d981787"
    sha256 cellar: :any_skip_relocation, ventura:       "4b80e7b3fd29a4e2c4a79dd41a0d21d01493fa078bc26ee2f128d976a59b0449"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6368bca51dd0e279fc2fd311ddc3fb627b32c0bd2a56c9f5336a15c2c2a99a97"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # Doesn't work with `generate_completions_from_executable`
    # Taken from `.goreleaser` directory
    system bin/"stripe", "completion", "--shell", "bash"
    system bin/"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh" => "_stripe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
  end
end

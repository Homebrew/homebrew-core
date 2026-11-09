class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.9.tar.gz"
  sha256 "e3787cf7215268e694351203cfd8529656f6b95c6452f2ca01cfdabe56f0aafe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e94f27ba2cfb13d9f434745cba34782eecf1b6c378910403ebc985edd1b3950f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e94f27ba2cfb13d9f434745cba34782eecf1b6c378910403ebc985edd1b3950f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e94f27ba2cfb13d9f434745cba34782eecf1b6c378910403ebc985edd1b3950f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b81f5ecbb1da0354836c975f8519e311d098486b9c16dec32069e605a65d1493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8a6cb60f7f118cd39688068f8671a8f675e1f802be96f972f35535e2866805df"
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

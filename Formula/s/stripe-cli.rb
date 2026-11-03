class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.8.tar.gz"
  sha256 "5df08cf126dc789f0332978c8784ef421e297d8ba4aeccc60c3be5a588618146"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7be6f01f095f283104dc76060b40d19d76e7cedd3c3563c2463d49d2c89a3526"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7be6f01f095f283104dc76060b40d19d76e7cedd3c3563c2463d49d2c89a3526"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7be6f01f095f283104dc76060b40d19d76e7cedd3c3563c2463d49d2c89a3526"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1a4a29248e6f71af8666189da576c240ca3ae9d10dffd209369c719bc055633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "74009fb6bf091729f82668fdfd341db5933a83c97f52e9c94be059d26e5a7389"
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

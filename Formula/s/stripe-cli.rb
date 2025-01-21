class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.23.3.tar.gz"
  sha256 "cd6bad3ccdae6d2b79ca61a9255cef83381683a7cfcdc2de08ad8e821cb71128"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db45f35031c0434384c49a441eea5eb2c875449765143c1ef7a2b00f2d0ca889"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef7eb2ab99f20143e7cefcfa35496b32e539dfef3e208c016a5dd672dfb9ae3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3282fdfcb7c3793921945629297fb8ed8f36524a4f02459d6f16bf198619a42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48b5804cefe6fc738fec1f238649d6d997e6808f4efafdfeb89b1d118053994"
    sha256 cellar: :any_skip_relocation, ventura:       "a5dce5c6c0f706c79402ac84c6ec8d5f227b0f455ef683ae070c6b50d53253ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dedb25f4ffee54e0af70e98624e1996d04e0f6aab7c7f463734fdccdb15756fd"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/ef36be45f56821a33ac175bb4f483f08cca3f458.patch?full_index=1"
    sha256 "e64d6ab6ed1b93749b8d65a429b0132063fb86520960b7d0c87fa6f7f9221252"
  end

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

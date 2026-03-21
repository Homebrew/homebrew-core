class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.38.0.tar.gz"
  sha256 "0f05727b38b7140126665cc838259e11d4123d1e84c2836cd0a56e945a6b14ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c198cd6deb2277fc6cd203baf45f690fcd43ab20456844031cbf769b299bd13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62b6a642037cc0d29878e114c5d0c7c3684383dcf04ca401c308655dc27189c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ac202f60f6580ba6c2e4965e0aa561bd489b5b7b0e4be66a5cba16894d2278d"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdf986c07e5c26a351376337cc00565d34891f556c9b4df21bdd33c748cae995"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e93d22bdbcff0573dd1e96b44cfc04d844aabd138c93d903c83c592654c28dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "575e2395331a2b77a85b248e76cb47e4cbadc18e32f00249ebbfae2ed55501fa"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
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

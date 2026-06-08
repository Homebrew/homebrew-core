class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.42.1.tar.gz"
  sha256 "3cd8054df1ca218723be53538389fe027739f4a8aae1674100108a931b318cc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb974761cef95446d37cad4d847d68649c09aa0a322d4b252971f4a75b24ba4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22fb98c54f9077d5c82b24a615d53002695254f87e01fc8300facfdb3bf27af0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825ed170e062570875b53973fe2daab98fac5300544de3926f6eec879e4d0024"
    sha256 cellar: :any_skip_relocation, sonoma:        "98f12c7039021acf7d19b2a6bf7ace1e28399716b19912c97f57689ff0af8917"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40cb7706c7676dfc9e4c5ba8af3317fdafd01e57da6b17346016179101006806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e8500f6d85149ced938af74f554f4f48516498e5f2ef76569ddd988c070aeb5"
  end

  depends_on "go" => :build

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

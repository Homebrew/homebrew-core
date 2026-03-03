class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.37.2.tar.gz"
  sha256 "02358e9eea94a07f7dced1f4bd2f042b166529d21fc4f90200c3e3f583bebdbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b061a5f2006a2f02dd7167ee688f3f491ef9af22c56ca599b3833d2cc2160337"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb58b02672e205b5f3fddf43fd01fb1a0a21f7e736cf9dee97653a49b2a947cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aadea95a60cc385c5d9d6c50ca0787376b3b7bf36b3b77a49ebdbb3ff2479f86"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfbbbe29818b733d8597181c13cd875563755accbdd10152db28ad39f0ba3f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15fa6037a00b0c38be9d586e7fe640a93a0c71afe7c8ad8e312f8afce517c939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2259ee92c791fa4e82b66ad0d05e1486697e350fb570827ef50bd934410b62"
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

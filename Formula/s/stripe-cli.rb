class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.34.0.tar.gz"
  sha256 "41939edbe604bb34c66e97881a65e97a3c03faf8ce415f5c0841e521ceaead4e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79e073cf5635351759b83f0339ff4e3bf3b400f641224f711536062efddd011b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23bfd767baa2e8c27bcea12941523b3b3b39ad955ffd3142ec2030d04c1b9cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eb5ffde6ea638b8ebca1553719b366e09a65e3533fdae67cb2022d6b63e4092"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1622c6a4e7b7e890fd97cfa8a46539d00fec68463abcbf025be682e4162b955"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6429e24709f8d007dd3044676a84f2f99eb17a7b1fa339aef3647feb6ebaf253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "324fc9451b92822f7224da44d62553c214541f0c68a4d892f9eadf53cd38b8ed"
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

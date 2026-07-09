class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.6.tar.gz"
  sha256 "96ef3e5c7607cf88dcf0fe83d766f6ab14697730d901637522eaaa651b54b6f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66ec29a639a69f6db86978bf75790538541ac2faf9eb047d757f5b3004bbed46"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66ec29a639a69f6db86978bf75790538541ac2faf9eb047d757f5b3004bbed46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "66ec29a639a69f6db86978bf75790538541ac2faf9eb047d757f5b3004bbed46"
    sha256 cellar: :any_skip_relocation, sonoma:        "9196a0bbcd6f0e306b685040e664660afa8e97e6a5691aa2428c526d1f806e11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d30e35707e64b77d06e4d4791dc1670084e1304fdc2ba70b5937f48ec7998076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "765b8cd82aba3c074c09ec9f25debc67fb03557a28e7c204277a318823daacbd"
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

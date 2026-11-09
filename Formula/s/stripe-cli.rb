class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.9.tar.gz"
  sha256 "e3787cf7215268e694351203cfd8529656f6b95c6452f2ca01cfdabe56f0aafe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea29b314338f279508bab8d54a9e4e21c1616b477f4f2bb2460ac3ceb46c6777"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea29b314338f279508bab8d54a9e4e21c1616b477f4f2bb2460ac3ceb46c6777"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea29b314338f279508bab8d54a9e4e21c1616b477f4f2bb2460ac3ceb46c6777"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e310c81a798441240e6c49c11a7ed5d7bd5f187b026b3704ba9cee78a570a183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "937d105bacdfb6c897ca8ec1909d394317bb7e5395abd8f5f92402d17e22e024"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.8.tar.gz"
  sha256 "cdd4bc6f3c1ff9b78bcfe90385c52ebffbcae29f296ffe9d1bbe98d256264cf8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c34a5445681ed3183ba0b16dbc71eb1aacdf1ce2c6a133bd8e3a7baca1bc0a60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e64e57eec7665fc320d21c335d6d63ed0173c9d0b035a46dac47d4ec1b76e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "942c3af81cba29832dab44f8902550bd8058e0b6f7ea84f9a9b8d1c4019c67ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "de0eddc19476cd1e46d6a063cc0ffcc358809ddd92ed1e208fb98ea7e5182d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92951ed3f03a1777471eee1a97a27e27131d1a23a47c6612f2eb565c758e060e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fda73b66b70bd277d1bbb8989b00a90f785a1d9502b7931978302c7a224ec3b9"
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

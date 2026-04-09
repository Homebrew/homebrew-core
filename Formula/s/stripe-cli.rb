class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.3.tar.gz"
  sha256 "4289392dc9444d1e7899bea6e4f387d7d24ade75523a301ace7e26d1603b5477"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "79938a718389794bae4279ba357784e13a034832ea4c648770d04a6db6bc2c80"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99ee48cfca884e00da13621cc5f7631ca135375159a5a62fd8f8d6ad2625ae6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4bcb4d37fca561f6ceb294d58dbf6cc9328d01087b722d980b3c708484e15e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b996250cbd700eac2b19c446c7977ee5b749732e2887be699ca1cfa1807f6ef9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afe6843fc35b04a428e2c1e9515d0bbd745e945a15098a1a556e3d1d4dbd8d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc9767c6c5d61537c4a737e3121ad7d7e1e47befafaabd6f5f7e23c2c6338913"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # TODO: see if fish support is added, ref: https://github.com/stripe/stripe-cli/pull/1282
    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell",
                                         shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha 2>&1", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

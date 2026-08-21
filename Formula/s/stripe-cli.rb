class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.3.tar.gz"
  sha256 "a0123d95fe2e0195f74f3259b6968d843e4b0a66fa84e28ae4dbe72facaccb06"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1984b2bd9b886087aed9aedf34cd6dc074f05b354bdf411badc06bf89b782246"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1984b2bd9b886087aed9aedf34cd6dc074f05b354bdf411badc06bf89b782246"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1984b2bd9b886087aed9aedf34cd6dc074f05b354bdf411badc06bf89b782246"
    sha256 cellar: :any_skip_relocation, sonoma:        "f97c92c17b698ce9f5b15b0aa3a3b2c66255de45f54ea31c6426b787c1b3e4f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bb08a08412d3df978afe557beb80879993f60b5056cf02023af921d2a4fa7fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c14d880709bd0e33b5c789f5d6d2d928b570e231b260909f8c480333c6943947"
  end

  depends_on "go" => :build

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

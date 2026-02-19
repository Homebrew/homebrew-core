class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "2d930f81b64f6858c13a2d2247bd74161f90cc94d79144f9135e7b20fb890638"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b731af1a39e935b1d73c13c9bcd2f8d2fa7a02cf2482be6ae62cab85b5a3cafd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39fa979616c4b0ffa7de80ba3464bb88535344154f1b24c153a25a981f685207"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6c32fd9b6f3ac9a7f10fc9f00b790f76dd5f8c58dcaadd4c3b1324b81977c4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b55d1dab2e21cde34a14aa7a9db5b7ad01e59532be1f364acfac8f4d7734e619"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "00378852714792bd8f178da8c5371ee4b9af9f553fb34f6b554cc5e194c4e4cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e852258598150ee9aace17f7a9ea2871484e4428fb1dbce80ee18d61601fa93"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.10.tar.gz"
  sha256 "5531f5b056f6cfef276b6138d51fe9291608607d425e807b2dbac0463921d8ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2d2daa74fabc57a228d8eb83a3e85e1fbe381070b34bf06dfcab2defdaf847e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2d2daa74fabc57a228d8eb83a3e85e1fbe381070b34bf06dfcab2defdaf847e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d2daa74fabc57a228d8eb83a3e85e1fbe381070b34bf06dfcab2defdaf847e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f770f037150f4d92448770e3a3c972972b6dc2d1be52fd770d3e34c3c9d8d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "34c50fe0baf6b80767975c8123d6a056f7ee358914b233b64cac29c2af0a8e46"
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

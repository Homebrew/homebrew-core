class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.14.tar.gz"
  sha256 "32f939a97d38be16cb275d2ed836dc0f5ac596fb48f36cf16d9378c7fb5eb3ed"
  license "Apache-2.0"

  # Upstream creates releases as pre-releases before promoting them
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e37cb9ed49b699e3ca3a51d583e63e6ffb015c944a9e4dae8cefbd5d53feb67"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e37cb9ed49b699e3ca3a51d583e63e6ffb015c944a9e4dae8cefbd5d53feb67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e37cb9ed49b699e3ca3a51d583e63e6ffb015c944a9e4dae8cefbd5d53feb67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "734470656b8d5d70dc1a9a0bb821b5351b95dd2394826e452d8a5ce15fcb92ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bbc62f37809585d25c19ffde59b8c3822b8d6116a6da9b2617ac66aff17a9db1"
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

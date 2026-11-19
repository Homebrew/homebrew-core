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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b561d60fc1af7dbcdca40ab7d3fa65cee78140e068567c28a654077e186b206f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b561d60fc1af7dbcdca40ab7d3fa65cee78140e068567c28a654077e186b206f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b561d60fc1af7dbcdca40ab7d3fa65cee78140e068567c28a654077e186b206f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3b8e6c92a9a3af1ce3c8348b0e477bfeb41f0ffdcc6bc566664560311e77419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5e726cf5966f7205bf044e4db0879fb310b4bdd86949445340f05dad311b5074"
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

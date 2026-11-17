class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.12.tar.gz"
  sha256 "6cf57e3a86fd1e6d454c551087755518a96061e1d0a07f588a1efc0d8d8b86d4"
  license "Apache-2.0"

  # Upstream creates releases as pre-releases before promoting them
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9d57cc76766f57d8e1e8993c2f93317437462de87feb957527c49bfac714b13"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d9d57cc76766f57d8e1e8993c2f93317437462de87feb957527c49bfac714b13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d9d57cc76766f57d8e1e8993c2f93317437462de87feb957527c49bfac714b13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "aa81a36fd34f74c8832623ec1d324f7041b861637899e60cd3e7f608c9ccf60b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e29890ba3d47955ad052db7280391a15fc08bb9c205906ed7a51df99f00a61ff"
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

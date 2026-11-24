class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.55.15.tar.gz"
  sha256 "a514043797598ad7544276c387178776711a03811a961c1b22c21aeff08f6d22"
  license "Apache-2.0"

  # Upstream creates releases as pre-releases before promoting them
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "e3badc5e919bd2e1d6452eff3f7457ec4ab4b04658a85413da9ba8185d8e151d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f13be1ff5caca810da068bbb501d44a4227cd32d1d2ba30140a365f27a56516b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f13be1ff5caca810da068bbb501d44a4227cd32d1d2ba30140a365f27a56516b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f13be1ff5caca810da068bbb501d44a4227cd32d1d2ba30140a365f27a56516b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ce51c874a60223ef2b8d0e0c2d73b769c57dac0d444acb00a59b7eb38f3e0c2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "887265ab807eb36b0924212a764a00e18e316a457e12b69ad096dff6bb085761"
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

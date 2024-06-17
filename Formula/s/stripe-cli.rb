class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "91f74d7c1a349ae112ea6459ec685004e316918d429f710b52d4374672c710ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e38db75479e17ad2e53b5805d6cefe7373e2a98d76ce581f71f312970c7c0530"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1df60a7fb6c036bda5a341b268b1c1d155b149366d6e0ef3c87c3c9401ddfc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b548abb7c88b55e44219a92ad5b699a142894846e1ec6f1a9db1130f29f81253"
    sha256 cellar: :any_skip_relocation, sonoma:         "e67b83b9dea1e545802ac0c9b4e52de5302f63b09b2d2597be38b753e939c2d4"
    sha256 cellar: :any_skip_relocation, ventura:        "e50986e96e31158987869a12438e1ed915604d57b16043cff995e2674821786e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a26198fc2f455377592e7112468c18d753055f6cdcabd981c2ada373e2eec48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0989e6dcf91ef70df90b4c81bd1d56c4edf033f98a8e7c6309a7dc7d152991fb"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # Doesn't work with `generate_completions_from_executable`
    # Taken from `.goreleaser` directory
    system bin/"stripe", "completion", "--shell", "bash"
    system bin/"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh" => "_stripe"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
  end
end

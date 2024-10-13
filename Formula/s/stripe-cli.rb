class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.21.8.tar.gz"
  sha256 "7b19bf53df2668c86ffbe18e2d72c9f80a51f88d63eaf419a37e1a7f7fd5071e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50a38089d2d41108fafd3fb6144a51dd86c267d557401e163159040aa6b88008"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "429f610d8b5c4a3ca16d86c3b1d2c423870d35683a0cd866ed20ff8cba865efa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6b5de1c8d8f03b77edcc1e96b735f4692dba0f5ffe27e3063b691c8fe4a84e6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "93da5df351efa2a8780decbba76c36a9be1e2aa0acd7d306f86975f7057e406b"
    sha256 cellar: :any_skip_relocation, ventura:       "956e35d85e412e85073e22b7e7468d40651feac8d91195ee707311ddbdaf3868"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abe393a28aa3869fbe2bec18e92546c037824fdaeabbded211d009ceb43319b2"
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

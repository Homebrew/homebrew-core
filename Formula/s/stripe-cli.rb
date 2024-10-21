class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.21.10.tar.gz"
  sha256 "f5fe47c5a14be7a01ecd6204659f7c8357a4ade4e925a164f21330557a89e1c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32b7cee06c0bc64c25ca40b56b0d42e2d8b270167bf7387079f9a6b2e3aea8a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f08cd3ed9d58b43f60623593f6fef2bffd17264c6168565a41b3121eea6ac85"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "60911dc6a9c3e5dad14aa24ed1c41bdee9cce19f4b514c7e0438ab6ea9195ed4"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcc05539a04c2dd65efa5a066051477e0e4404b5bbecc0d10f7bbfa135b70eaf"
    sha256 cellar: :any_skip_relocation, ventura:       "b81af745e2eac206a935d60433920a70376dcb31fe28a52d8d266ed50d394717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55f0306c4eee4f5b3eb0947efd027bf7ab2e3318424be62a7d92b50ba6e52f03"
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

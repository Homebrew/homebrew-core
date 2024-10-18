class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.21.10.tar.gz"
  sha256 "f5fe47c5a14be7a01ecd6204659f7c8357a4ade4e925a164f21330557a89e1c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3eac117e69cc8c24ab2df2e8e7ea222cc9e7327775791a8ac2f65223ed0a8f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dfdb844d4213da5ce4562ac4e1622e9b3413477bddd725ed6f1cc43e4f38c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85e869c40dc2333c4fca0273a0a3bc42dbf46c469426e3abb1fb1a32a12e8582"
    sha256 cellar: :any_skip_relocation, sonoma:        "da04fc71099375ed01c6f248d8c5909cae64c7ca7b1ecdfc8f326677a5328e32"
    sha256 cellar: :any_skip_relocation, ventura:       "3375b893006ba591ccea3d479a246aa399be99dfc621bca63d3d4799032be985"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53452970572e61974eb6bc95178b8aff47c3b1625560cf602da4aaf998784ee9"
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

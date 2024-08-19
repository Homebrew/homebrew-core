class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.21.2.tar.gz"
  sha256 "4e24c06afa54e94c4f30ccec217fa788b877e474af340f51f64905b4a51fbe7b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "746a65c821d71e20f9013987dd9d951811bbe3e00ea1ad8e8cfb54be147f22eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c440851b247fe47a8f753f408de2d794a548c6d9a8e31df1effe4533b5f4495a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4585c873938a9e689a8684d4dcf4190435abaceca41b34c2d79bbf425a8ad3b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b1b659d90837a1aedbffa8d299b39ac5bd7cf1e9090f9295a80b60d010eb6c3"
    sha256 cellar: :any_skip_relocation, ventura:        "1dfc1b1e3ae5738997ca8deaf25a6726c0d93e5e989c6634224c47eecdd8ccea"
    sha256 cellar: :any_skip_relocation, monterey:       "225c5cc262c111d1d65a5bb9b9025d2f1a8feaa33ccc0371ad26a0ec95c021d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35b657232c08d999d2f80f270d4427b11ed59b962f1cb8822a482e399e552caf"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.43.4.tar.gz"
  sha256 "c21a487154de44c3a898b2a7ef99201ba6524121b14c43687e17e572210dfdfb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01b231980e26b219ff72bce1e8910f5519175748267d663fe442e78b15719cf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01b231980e26b219ff72bce1e8910f5519175748267d663fe442e78b15719cf8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01b231980e26b219ff72bce1e8910f5519175748267d663fe442e78b15719cf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4490b02463f6bf4a23dcbbbd71504ca524f94492a5818e1c102698a4bc7cb3b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40b24f652447c111eb9c0dd82c616fc2bda1338e103a192c180bdd1993fc330a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b55c11d032f7b4bf70db53d0261cf66597d37c612d549a60679e88b6bbc093e8"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
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

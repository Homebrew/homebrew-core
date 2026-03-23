class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.38.1.tar.gz"
  sha256 "e48449971fd88e4019a369bed8e09f7ab3454996bf9b4aa4868039f31d5a8b81"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bd4e786db8cf14046fbda385f5a50f13eea3460db9086458bf13047f67b91ef7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b2d87bb4039a6b05253a1ae4a83fa5018f5305d5b45351267559e9b714fab864"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "414d7f0ac7dc9dc497a9c8330b86ccdb8f663fd5f080fbe47f064572aa58998d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7dcce20b21b08f62cf2879a65339bcfada27099309e2b53843c222a9b9e99a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10bfe1ae979c84e068079a09eaced1c820d1edec7fc1105e78d58da4a95bccee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "225c1bc490ed562a8202ff71c96ae53b143554ffad4153b9d86fa1da6c6b980a"
  end

  depends_on "go" => :build

  def install
    # See configuration in `.goreleaser` directory
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[-s -w -X github.com/stripe/stripe-cli/pkg/version.Version=#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"stripe"), "cmd/stripe/main.go"

    # TODO: see if fish support is added, ref: https://github.com/stripe/stripe-cli/pull/1282
    generate_completions_from_executable(bin/"stripe", "completion", "--write-to-stdout", "--shell",
                                         shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stripe version")
    assert_match "secret or restricted key",
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

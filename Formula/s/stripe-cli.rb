class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.50.4.tar.gz"
  sha256 "c18b77cc72e32816f3f571b794bcdf1532a27384439a4d44ea7f18375e007085"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9af7bc09a681f6a9fa384cc496d07d6607f2bbab5e8eef314ef4daa955e75a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9af7bc09a681f6a9fa384cc496d07d6607f2bbab5e8eef314ef4daa955e75a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9af7bc09a681f6a9fa384cc496d07d6607f2bbab5e8eef314ef4daa955e75a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9aaee20fe91e5d32733c31515b2e4b171ca16a6a54eaf2accd9a5ddedbafc238"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57d63969a3b772029e3d3f5778eebb4651a416137988b2aca3f26c0a6568d565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eadcb34e53c061d6017539c5a6750e93404bc482bdf06ca9144f6466864bca0b"
  end

  depends_on "go" => :build

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

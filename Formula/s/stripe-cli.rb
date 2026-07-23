class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.44.0.tar.gz"
  sha256 "37f127d8edf774bc8a8abb21546b37cfb943bb118ccde35bd24dcfe249647bc2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "836179c77e3a6a3da48f4c83d463b777f2aaa2fa06b4247973fb060cf5173324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "836179c77e3a6a3da48f4c83d463b777f2aaa2fa06b4247973fb060cf5173324"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "836179c77e3a6a3da48f4c83d463b777f2aaa2fa06b4247973fb060cf5173324"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b01da6a52db516251958668c178778c65153c4012926032896d53c3636076d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b76e61871ccbcccdb1923a1dcdbf57073644faab5ba072af4e874e012a506d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3765f66c3d2644778d6264fd5ba1206b918de07b1576fe79016e2530d029bfd8"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "a87bf4f2aae9f17576a1ec1b47b5c71307eb1b062de71aae97827d4d086d7375"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "385ac7cedd93d57e22b110a573a0dd1b372066d10a9f5fd188cbdb3ec3828abc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d169732cf8d07f6ffe5e8bacd1a438020f9a3e34ae5f87dc9505472e32496489"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf6de4f6958baf8c81b4f8ae7034f7bed41bb71044f6ceb1f736f76c9791e974"
    sha256 cellar: :any_skip_relocation, sonoma:        "d39fe4a0098119a9136f5d3cb862f8f8709f82bd0d6ae243e8cad92a7eb47a8c"
    sha256 cellar: :any_skip_relocation, ventura:       "6da0424e28ea9200bf465eb8c6e4cdf81d0a1d95099d2bff8ff26f51d58a7d1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e321291a381dcb08a32cc505300eab8c41a374efdb95cec4c728f266f22dd56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef22ef69e9c01cd7663352b291b63186df4b18bf9b3b92cd13fe7e0e1b2bc51d"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/de62a98881671ce83973e1b696d3a7ea820b8d0e.patch?full_index=1"
    sha256 "2b30ee04680e16b5648495e2fe93db3362931cf7151b1daa1f7e95023b690db8"
  end

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
                 shell_output("#{bin}/stripe --api-key=not_real_key get ch_1EGYgUByst5pquEtjb0EkYha", 1)
    assert_match "-F __start_stripe",
                 shell_output("bash -c 'source #{bash_completion}/stripe && complete -p stripe'")
  end
end

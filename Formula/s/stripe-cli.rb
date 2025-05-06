class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.27.0.tar.gz"
  sha256 "217f1462003fb7dd6e8ca14507211301ef128107ded2fb03cc19cdf608a9fec4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da1b9fa0419c5e31d804191ac6ab9a6147e4a9e5e0baebdc905ef031fedb02f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0f7ced54283e77628ba5db93ae35e37aa6f71c3ece339f147c74b7fe4350170"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "26a1d8cbabe334c407ddbb61386004dc3d445c3009ae800d2b9d436abdba0319"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fc7c85bbb01ab2276896cc208ea7cb29615147b47bae10f5cbfdfb1f55adb1c"
    sha256 cellar: :any_skip_relocation, ventura:       "2586abf0092dd9080ff993e4ef7a837aaa8620f260228d7490d778d1bbfa736d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8996ac34581849c34f7d86c5332e550e0185e789c5826e5da3d16603adfb442"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54e05811de441326503f42f3f29f724f894fb975bc5e9c56f3dfbd487aedb14f"
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

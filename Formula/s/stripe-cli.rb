class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "36a5da61eaae0d09281ea60b479a6ef7f682a4e906697a4794c8317acb9fed79"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0331f3d9d1295d581a12e89a39fa6b36cff7d957e7926e5594550b717b8ce909"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f5e566dce1d5da52a61948ec740808e2e748a1cb3611ad7f090d374887377c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e3bb04a737a8eae992c25563e6d5f91afa637df0788a6733b941e9d6e2a2afa"
    sha256 cellar: :any_skip_relocation, sonoma:        "5991c54383f9dd34bc6c8bc6e7b262dfeb258e9cc812c1af1f55292a34e51774"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5b6ab55602cfa833631685cf4194ee769f2beeae99298534f753a1027b7f1d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5a41e496707dd79d979338ef437357c4a2c70e843d1716c1982dc6f59040d61"
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

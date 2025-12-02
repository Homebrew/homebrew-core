class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "960ecfa3ec18a18776012d705bf3962249be8b9c5246c01288c09451f78103e3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bcd8c5d064a0b27698a21f9dfae58f29f395fe040c3fe49569de44ca3c0b2345"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e0945011bc1c83ba4ea85a290d15384e741494cc6187e66df081a70aa2818fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3890eb336a203608e562f16471c608836291d563a94dc5d27f71740d712b8648"
    sha256 cellar: :any_skip_relocation, sonoma:        "33f382a404e4ef5cf4907d36ae84a4f3eefc0e280612c900e6e8f4d8f19cf7c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0041893ecf448095244f700c6594f6a1086f7964e124261e38fa0a4542aef9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5934403daab3e9a01b6351dca4f4dc763803c912fe4c7ab86f027361dd931280"
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

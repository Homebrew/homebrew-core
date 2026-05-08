class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.9.tar.gz"
  sha256 "dcb2890fadc1a6ef008cc316f61f1025c7a412c9bd9766a5a61c098813b05ff4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a045f6d20443ffe4f4766b28102b7c5bd1e7991594d6c2743512868900a475"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "530d15b13d5e89f7e806aed5efe312f593c4f9456ed798848f054eadc610e737"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04a60c9816baec10dc08039bdc4e77a674b3a3708596914c211e1f6b416bc218"
    sha256 cellar: :any_skip_relocation, sonoma:        "17f1b320bbf17d0b674e58a0f66adf97ac8cb76f065d664e7dfeb5c337253ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "932c2e6dab0e1a6a3cfe3f33e49504bb51a1468e2e9ce5dc5a570b451fdf39b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98c42a291e629c616c973b3eef20d0cafe081eb5b90c0256ab710cac241faa1"
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

class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.23.8.tar.gz"
  sha256 "0f399e6da38d57dea07c59728eee17fe44c9f96a83427801b9bb196d3255e8da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "04936f4e38bb683ad0639081225e0dfc79c97d2ff07da9802696242cdabe5f41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c30d351399c587078a2ec6b73d182f9f79414a050d2a05094c04b7dd753aaa82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b0cd70ab93adc99155dac9874cad9ab08435d7cee2d71ed180009bf1a5784db3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b123495584ba0c196230305ec261fed932c7f70af86c510f1b8a5e93017f5901"
    sha256 cellar: :any_skip_relocation, ventura:       "9fa9b9416cd2f305134d5d3d79a304615a2e68d9fe9a4282b2a3be8f0c488013"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3e4f81b76d744c208eb196fe2523d082ffb49f001a15b59236661093325f93c"
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

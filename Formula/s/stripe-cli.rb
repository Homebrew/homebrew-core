class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.31.0.tar.gz"
  sha256 "c4785551b6469510724681e35bebd8894858ea3ebdbf40b8b01b68f87f018eb4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "35a1e3d2f841d5b03d08ad976fc23e8283a4b4169ced00e6029ac1d19d364082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e3e4571612fd90def04721c7f33a9c030512c2ec9a948118a04fb509d98ae58"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92ddfc10c0d20d223af599724009de5d5142682f6abfe15b8d22b249861b878a"
    sha256 cellar: :any_skip_relocation, sonoma:        "76ed00acca012dd215477d9a53402372cd3053ea6b8d040a47edce006a4169b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b3c03fca5e71bd934a7cb08fdad72b684cea43280c61f7313b82e7afdc0afa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "509ebeb3fb125ed80f7278a896bac6cc7532d46bb5ebb7bdd512af50cfb7f760"
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

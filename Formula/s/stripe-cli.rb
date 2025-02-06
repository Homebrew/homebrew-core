class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.23.10.tar.gz"
  sha256 "80dd540e560f01c942d39380faa51e8a05ed8d9591ac3a01219e78a1980c3036"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0973f831b687fddd5f72ffef2d1075726aba3f2550f35b3b8a3a1fe931bce75c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdd03022c03103e7e1738172d6e7d69601be8adfdf606739802c581be769dd88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "373eb303c02a14b2c3cb2bd2bb85c545c16c542628f170e1f34c9f72feeba70a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd830a48fa2e896e3fbce114c7af44ce8390caf089b0a2e8a662bd0c7439e6a"
    sha256 cellar: :any_skip_relocation, ventura:       "81077cec4a725b1eea611999ace4bef5600e559442177343c1e85e4b616a1764"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "811e564232c062b06c3231580ea04fd15dacd3e00bf1c801f206a8f631e84938"
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

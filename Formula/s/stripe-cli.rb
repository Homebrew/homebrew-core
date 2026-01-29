class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.35.0.tar.gz"
  sha256 "8a3867c0f119556245e34913c55cd74d540fd517a1d49a9bc623f33bfa2562b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bc79a9c6ba52a5e108f8482d2e2be56ca4f54996ad75dad73583d3809a073b27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "560cd018b9024feddbd988b6ce0b958d3d5fcbefba454f553f594eea71917705"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6f6d56daa179a1b9da40a95d6a09e839cdeb1cd3bd72e58f8ca8afba395f595"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b0ff323441b0d1691efa5eda5b4e7c24afc95dbe13411f26f6677e52e8f121d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ffb7e166bba9d9226bc0d998a2831b87c8dfaaa7fbde8a557422e6c4f1c0c4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e02b5a22542733d14c7924d13a1095f96d56a2d0d9ba389d11144dcfb57a0537"
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

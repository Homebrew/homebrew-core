class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "a54917683819e323aaf650248e422c0f5b23c1176948e7e5d9764ae68a959180"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e56a3d7636bf0494e2ddb786642a5ca3676ce1d89d8c7e90dc84b1e9583ab17a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0a96af9c49e66975c4b2e1e6504b116650fffb2b9965993e7a574d6fc12e7f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a624b6a2265f2ba802817d0a9951f7140ade574aea66362750be101454dd2f4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fecaf0794d9ae07ed59e2a4f679fcbe872dfd3c7f514a9c712abed8fa22d2924"
    sha256 cellar: :any_skip_relocation, ventura:       "0050c7c370674cc41b025948b76be1d7501b1c0dd3a18c9beb9a9c71732f5899"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b481bffaca75eddaf8c11c01ac739242e85f17e7b9e9c30af6c2debc0a427c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "658f576b83f1b87dbd4c62051219f05eccfb0ccc7c3e170d1e42fa8c6d394f5d"
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

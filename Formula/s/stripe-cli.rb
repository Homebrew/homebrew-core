class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.30.0.tar.gz"
  sha256 "883e8fc3d62a4a7f046f754020c3183a48767c5dfa769f77985f04d21c900717"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9a26d73274def673218b31150c804262a78e86899ece178646c6176ce258f6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4e7507255de1f3d55d800baf29cb59ebcc952b2d7ad54df44ba74602b30569d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fb7323d6326c97736f618469e26d9be72e87751d8029258cdcbf56cbb0ea4a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19e5aa2bbd000f3a352a53409d172969ddcddadd4718da16baaadc4d19395ff7"
    sha256 cellar: :any_skip_relocation, sonoma:        "a79b2d68a8ec3c8f7d7f287a8c567398ae767dc730a793973c18407888e96420"
    sha256 cellar: :any_skip_relocation, ventura:       "d9a07f0d948b3fdbadb597a8bea922a633412aec1a176e4e69aaa49eca6c6079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70283f441fc65da322500aa7ea34d3348f5e1262c958093408e03f36952585f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6de120ae19f339ca7520086e109303aacb3ca2b365a9adc353552dd3e69788"
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

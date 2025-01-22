class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://stripe.com/docs/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.23.5.tar.gz"
  sha256 "8c3ccabc9defd3fcdb4b55ada67283aa76c3ed017f693995e115cf284dd99278"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d52bb4120c72f8f3bddb8e7c3cf462e8fabed85c4644ab5ed48e01d05d66788"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8adb46d7271da86349f530bf38d2101cfe7de3dbd7e9e2e921cf21d5160ee5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "154b0887fc3dccddfcc1feee080e1e83c2b56c6b2b1fbd73602185891cda7c40"
    sha256 cellar: :any_skip_relocation, sonoma:        "31378f9ffe692ce03283dd919011ca1285b6fdd1fe4955d7fa16a1ac129667e3"
    sha256 cellar: :any_skip_relocation, ventura:       "df94e1cee777a03fc7aafba58ab45155057631c8780d963a5aa40e1093233b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eece19de40ab602d80c88de73cfbe909f6cf538e6a62c43b0eaee5083d8eec8"
  end

  depends_on "go" => :build

  # fish completion support patch, upstream pr ref, https://github.com/stripe/stripe-cli/pull/1282
  patch do
    url "https://github.com/stripe/stripe-cli/commit/ef36be45f56821a33ac175bb4f483f08cca3f458.patch?full_index=1"
    sha256 "e64d6ab6ed1b93749b8d65a429b0132063fb86520960b7d0c87fa6f7f9221252"
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

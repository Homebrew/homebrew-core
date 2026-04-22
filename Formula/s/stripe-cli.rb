class StripeCli < Formula
  desc "Command-line tool for Stripe"
  homepage "https://docs.stripe.com/stripe-cli"
  url "https://github.com/stripe/stripe-cli/archive/refs/tags/v1.40.7.tar.gz"
  sha256 "e40e63bf9a7a649c32735113ee18c2fd25cc7a7fcf197d98de37e3ab8e4781ca"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02742f993594a3f782cb835e094e9c6804be6d3306e7955a3ece25e0de7b871b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fbea82711744a226c4a4dcc80532e54f470b7212c662eaa6425a681651b4e46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8329145487f48bc11dc213b9722de697f1ac3a097840a1cee0f1e960b69521c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "57558ed67e05bf1c0f08a16783a18ccd413e1c7cc9e85368a8a5b5484fbd39ca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180cb528023629df93ec1484766620497fa3f0aa76a140c69aafd9b0a890bb77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7c2f6c3d4ed3980ef2e185563146bcee89976f08495091bd06f7d20a98b19b6"
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

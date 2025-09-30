class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.33.0.tar.gz"
  sha256 "7cc0454183d72d7771fd25e7c8fd0469c4881827c3a36a3e3cbb912777b680d9"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66668c0879d7fad23e58a78e59d95cd3ecfb53b629a33424cb46ccff737d531d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad029df8104d039acb30ea8be713cdfcbc94925533906ee77dbde1d831b6d86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bfcb49e06a12a02865b7d80d468513de4c937797a465159fffbc42d0fbe3fcd"
    sha256 cellar: :any_skip_relocation, sonoma:        "54198cbb1a71e25dc36a967139389e132da727e7588523e7169724745a606a7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4798b0fc3db30c9d2d4f3fa08b70ac4f63b736fcab234adda1d0bb765a37f328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "165123411c10b0f0ba04e2d4d82d68fffc50f5c8dfd4de6b7d08524f9b8664cb"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "fed1e6c5307255096dbfa44760873889edf6927add52b479d9347520bf2bd8d9"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19b050cdeadf3b64ae8a611b2bd202fbc95b48a38984671d109b148e3a690de9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c76a0d94e56572f949fd64246052a0848cdfaee3e2b7c071182b0e856e9918c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d62883455650956bafe23938ab1f67c37c4bc6efcb1a58659f23f64ce630079b"
    sha256 cellar: :any_skip_relocation, sonoma:        "08202eb51f0b128a7f14cf6546d97284f1cbd79855272d636444f583b4325887"
    sha256 cellar: :any_skip_relocation, ventura:       "585f2e61287590fdb3bf4a024c84b7ddeebe9d73cab3cb720786ac862cc0a9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f823e648ed68f67a85886e3e45c53ce04baa7e565efcd1667913b58ba539b19e"
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

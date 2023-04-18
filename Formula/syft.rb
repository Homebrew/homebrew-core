class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.78.0",
      revision: "244b797a199458f504758c0e3a775572a021e629"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b0971e0a6b7b3862abe3edab577e2605e8f65eda85259e63e933aa67b6a3190"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db98e7ef9728bb2b9ab28bded6b1770c7bc478b234ac299c1c433bdb79f21c6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3f5cc96edc3db3ede1b1c2974ca100631f3ca47c8dbb508354bb5b65a165999"
    sha256 cellar: :any_skip_relocation, ventura:        "fa0b49e0437553c7033a09026014637a566ed06c017c2e5a609540c17d849173"
    sha256 cellar: :any_skip_relocation, monterey:       "1369b4f89b282ede7921edb796e3a2b5f7188b0cf3d20e1af0727ae7ea1e4b0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "044a6d2485d8f3288dd61df409587db83dd10dae68d1ffbbed778485d2e832f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd4b6a2d1c2a276e858654e5fe86737ed025665198d21e3d03d673a71df0905c"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

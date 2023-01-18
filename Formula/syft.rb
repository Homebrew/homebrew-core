class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.66.2",
      revision: "03971ace43b877e371c13e3f786c1f6c3a4ec507"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c9c059729fd3a5f97ca381d167a19c223d446023479acc4cf627d55847a61ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "673d53eedbaaac2e8503a19d67b93909e3406c9b3aa4e917727fdcc527b2d4f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22a8b118b2bed1e71f322146c260a275dd58bdc5f239d1810d6321ce30d6f647"
    sha256 cellar: :any_skip_relocation, ventura:        "ed8e7c5cd5bb75da4cb37747c5ae022602570fd41deaee74b307e857c9f57833"
    sha256 cellar: :any_skip_relocation, monterey:       "143ec00e01299005ef8379fd10c909cde2d98acae95c8b793fb2613529d2098d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad9885d2f2a49f7ca8ec9742f5f3d5e0a1c3fc42c315d753b8960de3bcab02e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3db90a80f9501ba67be3c7c5a62bd75e56e537fe8152a94f26a8049483411fa"
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

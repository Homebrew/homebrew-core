class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.83.1",
      revision: "a1bba36d514c3ff0f34635b9cdc9f07a92ea793b"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "350540d18343a6b97b6b0f9c0c37065b45cf545d8d609a89f3a1c56684242281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "190de7edff46164546a19c7a009cae8aeef9488e43e3f12b74cda2798b472455"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55d03cc90c7ffd773a68270851791f8396e3e7f0004acf9a1a59226f5cea9465"
    sha256 cellar: :any_skip_relocation, ventura:        "d2fc58f78314e805095a49ad9c85321f253f5fb7309b68db9ec40a4050ee5b8f"
    sha256 cellar: :any_skip_relocation, monterey:       "498269a7e479efe827688a0b4c57c53e2525c947b2edf80e9e18f149aac118ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "811edee4a4c9cc31b1d5fa97c9fe56ed4c7fbb6b80eb622b286475e66afc7eae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5bdca5e9f551e51b27e9a3d09eb7221fe58b1f97b983a127e7f25eb88e3c664"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v0.89.0.tar.gz"
  sha256 "e8b4bf1481f3101adb2881f35f95528cceb58470f1c568c7c05c2864031dfdaa"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "374c79feda2e4735dcee33a8a8168c94e24bd5d664d5a2841795a651b41f25d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7613c9c065db303464de14ecb64c2f2d05a9b8dc9ea32d5757d4f94b299a81f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f81527dd20b208bc23c55be79f42ce4ba9d150dac921a047f97e6a52c34a533b"
    sha256 cellar: :any_skip_relocation, ventura:        "6a6c17387b6553450b674c70412c4c57cd4f2925c9ac6fc91c85bbeed323d3eb"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb4f85e6346c8f4b2a3144c010e910562c3b956e865e998436b821036928778"
    sha256 cellar: :any_skip_relocation, big_sur:        "d44df5a38db06c33f20110181d65d9a9e7e64df4d51d102188db5c517385c03a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d0163d81fd88049c9f8fb2750e01511a0a2dc8a99fd704d9dc0827d43752ed"
  end

  depends_on "go" => :build

  # patch to build with go1.21, upstream PR, https://github.com/anchore/syft/pull/2067
  patch do
    url "https://github.com/anchore/syft/commit/aef33a0effe14830347867f24ab18aaac2d679a8.patch?full_index=1"
    sha256 "c78f11977678e324b550dddd0e1b3a18051cc015c4156792c72553b3c6ff14d0"
  end

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

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

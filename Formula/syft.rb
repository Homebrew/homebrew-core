class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.83.0",
      revision: "1764e1c3f6bd66781f8350d957a1f95e4d9ad3de"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce2a037ed79cd918b910add6b7c1e1ba91ed78aa72a16e52bbf5e8134a1aec3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c2f6beba42616d12083640a09827d601156e7c7a5088b49e152c60e5cafa12f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a14fbfce3f45bacb9271fbae681054e05e45beb70411ba3447bff5cf5518a8b7"
    sha256 cellar: :any_skip_relocation, ventura:        "6ee1d6ff7521ee66af307ca9e20439c89cbfc9d3b97c5e94f2dc8b0e9529d2bc"
    sha256 cellar: :any_skip_relocation, monterey:       "17df59e9d6f1de9bac3a83c768b5e3e5e8063ec9106df3ef16165988fb32d00a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c69ccaf9c49339d487de9964d8ac3063857779bf56c84d149c5fd5d4db5ae0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9319f41728dc02b57b2957d2142f249b108fb98d8f3895e75564e05bf620be9"
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

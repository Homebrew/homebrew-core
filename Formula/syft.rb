class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.73.0",
      revision: "aa151da5fe2a1b11502c852fd2d3ad462c1d245f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "21e345de62342e4aad4ea1b0010e917ea0f11a55136a84e95a4de7335407ddee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4347fdaa9edf20d1617f40310460b32afb27b839d0c9422ab27a8c43f5b9a1ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "713972abbaa76783578cf0e50da2a38e0db49382f89df2645a6beb9e9ef3c79f"
    sha256 cellar: :any_skip_relocation, ventura:        "6f49bb5200b3c07dcdf235920624b3e02e491e90fdb8c2935831ce12e3353795"
    sha256 cellar: :any_skip_relocation, monterey:       "050046ca0f9e91bb739b73cb6aa0cf9688e490c8786d977a35f9fbdf575cb439"
    sha256 cellar: :any_skip_relocation, big_sur:        "6db792590437035ea0390b41f409870e20be71dc0a23b00bb45786bd881584e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "942e7ebb1a6c38b1e48056520891be1a0678de612a4827b7b0fbd054c8f464cc"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.66.1",
      revision: "ac94bf530c7b1e6ee5df1ed0f9f6454fca8bc918"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ffffc836d4cd5c1365268d9f720e617298c2a58bea7bf92c54e4a8a481b38d66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a78ecba6531a7cd0c57cfb5ad187731ee31bcba033e37bc93b0e3d3fa6a874b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0354c9e9ff1e1eed1a5953ec2941a0eff8d6de8be71aa29ce80175f6a7d093ae"
    sha256 cellar: :any_skip_relocation, ventura:        "ac8d0de2eda9a01f623688a6c63a05e074b2d2d03da023ef8448baec02af3839"
    sha256 cellar: :any_skip_relocation, monterey:       "fad633196d87610068f35f09bc5669cf44bf21be57677415937bdb89060fdffd"
    sha256 cellar: :any_skip_relocation, big_sur:        "08a99b004847eea13066d6dcacc18c07d9a34f930574502610b9759ebc84ea27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1bf4c05abf9dedea0795f51810e0ce95ebefa53300c874bfed00837b75800ec"
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

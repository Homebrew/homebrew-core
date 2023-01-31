class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.69.1",
      revision: "1530ef354ffaf59cef6a02c949f2cdb82353954f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c15d77da0c91d5423f676433d21ae6529ccf7cc67d75696909ae4fbc43d11df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab13fe0542ccd5f266a11706fdcc6822518bd8cff5c2f8bd72b99548ec01505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37014babf576999ca971f47bfb42d05866b2bc890e01ae2289eff1c7246e166"
    sha256 cellar: :any_skip_relocation, ventura:        "58ff5353f8b5431966414a4788f8d8f31d242dcdacb9c4e3138c3699167ac459"
    sha256 cellar: :any_skip_relocation, monterey:       "1c3a006803cbf3395f4167e2ecf53296d624798f09a5710991cc12429cf368fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "3db594e8d58b89c7ab1dd7d3d632a920766b53b4fd984fe6c0ee60fb916449d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11974d21382d2d7d8d78d74c318c0ce9d552c32623eab8ff969f37fec0e1d21a"
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

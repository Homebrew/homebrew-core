class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.68.0",
      revision: "e58050bac045be672621047d5699b88884e2da62"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc8934d894b305697c25791a2ad6b10fd40ad2f6c422832cf292ed575ad87d85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6bc8127150abf86841c8c2c4dccaa20d07855941a3bcea683614d045a905bda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1617fc8cb3129de695836f52a5365583b03b56caf06b3f50214d66203bce97e2"
    sha256 cellar: :any_skip_relocation, ventura:        "9f543f5f7f0c3b68cf4a6e04eccdc72d1f36746dfe2cf53e6613011e74032996"
    sha256 cellar: :any_skip_relocation, monterey:       "4ad509e249fec5d5fb08585c7faa85b5970464660f21baa891b963b2d0ea109f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb1905e2909d567c8043baf3c22e63df43e0205bdd2d20526bc4b1693283a7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19277b8198baf5e8f23bd3e39d280751f0902beb223726a894778d75330c982e"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.68.1",
      revision: "4c0aef09b8d7fb78200b04416f474b90b79370de"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665240f493b9d1173446b4369265ce678f17fc8023b72505559f50b8c4e4742a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85f1d819ac126754c62d2d332cefe75cddef5b7cdf7640963d396aaeb05b419e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97eb307666448ba4cff2b6e7b8e62d7369f60e3a501ca006c5f4d43556d1bf06"
    sha256 cellar: :any_skip_relocation, ventura:        "5e44f428991037802272091287d751c294925328432e3d0dcf17df6e425d4877"
    sha256 cellar: :any_skip_relocation, monterey:       "39b74ee33576d37a2803f7b6795710baa9b241d9670ae32a122da71616700737"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1ca55f347708a18e8ece60b450817afd01e970507bf2b5a31467bd476b109b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d612479e723c01bf8a27539603d96ed68a15b79c9e2d9d4547ddc1df744fedf6"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.75.0",
      revision: "cc0a376aba43e7f9c5fe66320643f72088533838"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d3603ff2d1aa0c9b126362b81576faa28eba054ef50783d42ad3e2846b1b2ffc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e98c5a775b4522a573fdec6933ffc19e1a6c7158383ee862969a8f2d38ab1db8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4733b5d99708c1ccd40d6f7d8aefd7df7e3aca53224392a2a663eec2bf555f19"
    sha256 cellar: :any_skip_relocation, ventura:        "ed241b59542c92a111d3983bc15b612673235cb30483f53494b5b11ba74bfcc8"
    sha256 cellar: :any_skip_relocation, monterey:       "0fde5e19ab4a708f6bfc1dca12d46dc244142a8d5945bb1c693da1698aa3371e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dd9cb560ce7b986180f7b2079b9a28e28538d06e304ad94f7ca5f1efe9b8ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a42e2dd949f84779d5b90de26a11bffb0580db109f074fd0796c5b691e29e396"
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

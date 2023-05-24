class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.82.0",
      revision: "4ac8fdf6df0da4cd6f76820dbec9f490ee56bcba"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "733f4130dfa9784b304567a31a308fcdee0803e4ad55db6b513841e5b299c739"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd7d5d0497c3fdbdf93721d3d9ed8f72cb5a286b76c642220ea7636cd7862f32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2a90edc52e97ad4fb961817c17432d4d05498cb6d65e05b3570ee899c038fb3"
    sha256 cellar: :any_skip_relocation, ventura:        "c870744869d273bb545c3308260d808df9408bf887390e4888f647a9a23d898d"
    sha256 cellar: :any_skip_relocation, monterey:       "bf3adebc914f081c8bbe8ace177ee0d684be1bbec028a2d6b6394944bcd2629e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1bad665f38bca5fc8e8e5fade204e3cb98abf35ec1d43acb84e0441a2d505e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3af92632f1aceaeeef1f7cb48daecfef2cdcb78c71908f1d09a6bb2d04a9e12c"
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

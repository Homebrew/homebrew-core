class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.87.1",
      revision: "4762ba0943785fe778276893388e839e01787b45"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f434e6938a08e6979a78a188af7983c194d571ba48246bb9d97447c9dfacb9e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8401646eaa1aaaaa20ab206542b1f939ba46aaa836d666207aacee6c104d3511"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f278dabbaa98fe99997510943a14317be61f03a7f6a529ce143c46dd02bd5b85"
    sha256 cellar: :any_skip_relocation, ventura:        "e6c2d99ea1e7da070b2e4a936647896e2ece678d79a939aaf5a7a997daedf217"
    sha256 cellar: :any_skip_relocation, monterey:       "6416270e67a5763d9445e342e7a33b29b5947b69419e66dcf531ecbf9aefce5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6598cd1e94c026e1087130550d334fa12f18edb80f878ec0aebcf3e98c4403ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d52ba12f0cf825c2e0adcd35b4b04c362efdc8616fb256291bae84765b73d6b2"
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

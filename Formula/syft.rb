class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.74.0",
      revision: "5f90d0371873faf5eb8f2e748909b32294be6263"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e8b996d12b935f87fd1385bccd4aa5e19ac2e1fe5044bef187f040f2b1022220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de5d9a32f9fca50bfea1b378b49072d45f4b9a1aa1c4dc39a97c1bc71b2a9a75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e917f0bd2544c2f76da15dd7ebcbdb3c2b2f0a2b0ee988757f48ec214c80ed53"
    sha256 cellar: :any_skip_relocation, ventura:        "7b2f0c3d5f5e5266b6c5cfe1fd0f42cfa80ce8eb0090ffc55f9a20d598e6a6dc"
    sha256 cellar: :any_skip_relocation, monterey:       "536a4f7dd191c2a8fa1c4822778711e3cce067a95233a8e9ed4d7372eab3bd55"
    sha256 cellar: :any_skip_relocation, big_sur:        "057afa968dab48aa0e8f0ccee3a93fd5d1db61f97c6abf9de34fb5a192f1397b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a8db0dc3c0534ed2c6c331464fc238df5a3635f3281c5fed361035648d69163"
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

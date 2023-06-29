class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.84.0",
      revision: "5d54e6e847192f63db80c9a7ee23197476c632ce"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7836e53aeeecb58979bc2eea705819572fb5c3994036357c7390f677aad6d95f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ad17c6a14068747ed235468ba5e08575665504e65b1c41d9d41389f6c26578"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70085064172138061835638c13394ffe3aa9bba0949a38160db1f2f5799e9cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "a4d898a0261d7e65c01aa2b7d43af3e798c4d9f1b963da6f246e2c5bb9980e44"
    sha256 cellar: :any_skip_relocation, monterey:       "d1790e8a4efae92065be7df301e240812a08ba3c7485b7331598dd4cfe8865ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e278de1e995152871d0ba1a6f1a65ff1e48d822692ca04d2ea83b1f29dea7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71ebf82e08a67a9e69fb38c8af8534ff74c85d30e8dc216af01231cf0c1f91e0"
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

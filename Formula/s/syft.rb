class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v0.91.0.tar.gz"
  sha256 "f29cb3fd96b41ed48795e1f8fd81f3900505cf3dd84844b749db850d790f3768"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "def1f45fd271dc97eb3319d0f5933b81234c004f9f5987355f390800e7be4e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "962b306380c9e3aa35c82c6bc2cd4a297e28db5dcdc21eb1500bc6518e9fbb57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43c70fb35938d68fdd523350809062bfcb6f2ea497510654e8ec313eecd25761"
    sha256 cellar: :any_skip_relocation, ventura:        "6b38e0d02b97056da7ae4e6d53f493edde7a42c64707df762f0813f63819c85b"
    sha256 cellar: :any_skip_relocation, monterey:       "37e6d8f55fe2e9167748496ae2fe09693910b2b6c8a4923850091306aac5b135"
    sha256 cellar: :any_skip_relocation, big_sur:        "b69b3a0cbfff92b18f9364c7ec6d610803569ebcd410f7fb35d97c76feec3c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3af7b5f19faf7bed1df5478939dcc80f5babf498b89889f384686c8e38d08af"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    resource "homebrew-micronaut.cdx.json" do
      url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
      sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
    end

    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

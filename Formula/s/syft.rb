class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v0.93.0.tar.gz"
  sha256 "e56d1a46958719c8cf622c7a3571cea14a24ecffead91694e7a5f9dad1ee1be7"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "432e6eb907aa1dbe64cf58f34d0f3af39289b0aca4a91f2165d1a5a3fc040dfd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe469ad662930cb285fe892593eccaf3fa0b4afa8cca2c708b653773ed0bb7b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3b8f9c520fa0b6ebec36b272f9d5e07cd3b66109baccedecb568c35159eab82"
    sha256 cellar: :any_skip_relocation, sonoma:         "328e7976c18266e78b7544f1f03a367ff0c9c286585ad5c6860cdd3dca71d0a3"
    sha256 cellar: :any_skip_relocation, ventura:        "0d54fa6e1c026020e7b3f178d50cc2f12c293581f824b4adae921d38b48a99a4"
    sha256 cellar: :any_skip_relocation, monterey:       "f22f3ab77d144485a235460e686fec27d9156107beb4aa4de721b0f2e3dc59aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4645c559181161bd9130d7ffab73076449079337f6dfbe0c41ef63e047b1760"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.56.0.tar.gz"
  sha256 "b10a7b5f009746a0c30a4bc0a89d4e3f632fdd787a474bdb865810a17f1ac655"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e10e69de8186c6526c12e86f09d635bfebf79e67e3c42c1a0ddb0dec030924a4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ff5b58964af88e2f648114d1c1a0f22e3540ea79922c56b0dc75574709963ecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "180ee8f3aab0a97c68289dd8574bc9ebbfb08e3929aef7751f4a53ff72e11ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0f76f4e389b61df02f63718af0da64f290d375f00501ff0d285a01e4c76e92f9"
    sha256 cellar: :any,                 x86_64_linux:      "67aef3d6bba6383af572f9596af540adac5a50d2e413d9572e3f98cfeedff912"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json", :test do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    # Redirect stderr so the progress UI does not engage on the sandbox PTY and hang
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json 2>/dev/null")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

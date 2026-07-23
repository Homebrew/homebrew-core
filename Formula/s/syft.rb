class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.49.0.tar.gz"
  sha256 "7fa1d225a50be61a17c86a0d523412d60b3d8678a1864839217769d3472a8700"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ddef8041cb71debf7f17cc0925acc341e436fa515839a35ef5aa63f952e6c3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40034884cc2824f01a67bd8976058498887e4b7518d8fa470b83d38770822f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5aa5a70c0814558dcc4a084aa5bee7f66f3e5b72d9a6ecad23ef3afcf1bc0e14"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfd0dc1620edf35ebca1c1418284c53825ac1dda96632e3851d1d2ae4d99c08d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f84de4b1099c56161bb2c5ef4bf62700988a6aae8ab024eeb1b5e3719ef9d51e"
    sha256 cellar: :any,                 x86_64_linux:  "4ebae3abb87e67b11fcb3e3f95559c55f4f17cce38c6363723f7e812114e439e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
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

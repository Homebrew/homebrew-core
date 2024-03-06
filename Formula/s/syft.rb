class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "79852b27a0665da4e41139066c009aaeae488e82fd6b465129aed5734c5ac934"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "52eba589a0dec039e8d3f27048cf405583687d6032efe2bca32ff816e9aa35a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "facf4a6e642e39427e653f5c78a583d181949a5e7875eea1275c9467b00d06e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc595211dbd17199241fb7169f9c5e1c4de5b2b8ffb4bd3b02e70e2277ed77b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd701854f94ee4594845cb2b03ef7a9b28023227625141dbef384fd83ec7a55f"
    sha256 cellar: :any_skip_relocation, ventura:        "b32fc00f1864c777ace6ca49665b1843cf41a4526481c91de75b13e712267fd7"
    sha256 cellar: :any_skip_relocation, monterey:       "a537bee8c3b0a7956b0442760a1d6bc2b14f0314ead435710c8ef59626b12aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16272b3ea0c6d68af607b91e9ea15c1a38e02c8dae21cd075911c8ceca975a55"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

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

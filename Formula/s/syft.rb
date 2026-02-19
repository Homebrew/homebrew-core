class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.42.1.tar.gz"
  sha256 "527ed2a704f655a61194658263249aad38b65b0034087cd9cff153e238267bfc"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d78b57041acf2ca2e8834bfb1926e7382d5adf5a784ddaa13419d73d6d917fdc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b64639074342680ad8d76fa2b07441764316c9cafa40e3303c06b6e3cc31ffcf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c7ba0e8575185e186a9a3d04c587cbce2390b13c4737840d1fe0a17f36e8417"
    sha256 cellar: :any_skip_relocation, sonoma:        "e98331f10c5b55198c8d8eb579b08d89e5695c2cf3a580c5176e23d6e06d0dec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e33d2121f6387f56671f893eb04ea92b92103d8cde0852e46acf6a51697ce38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a78476fb93f30e7d0b44ee74148d9e0f6dceee3e75b61a74da8a2c522e375802"
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

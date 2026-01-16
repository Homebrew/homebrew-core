class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.40.1.tar.gz"
  sha256 "1ba363589cdb0454d45b0256e4c125eb213f5117cb614ceb39ebfd4947d11560"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbb7e88a65a1faba1d78144f941526ac84e2564df9fa3c846bfb8462ca9820d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d8b5526eb22dffed83cb117b86cea50a5f6338a0fc18795ef7fa14fbe74dfbd5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e92beec67bb7745b778dfb6e6a9a0a6c10c3fc7c451c235aa667e8e411276aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "6383c3edfebf5309f539989e9c65b73e6beee4efc26b3c4d40971e88d97e1071"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd0aef7487a111189899540782351e80c5d549154b7c0553fa6847adfa88984c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a6303e0dabece66bd2fa07ccb88d853da1db3f622354cea58d61efdfa11f96e"
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

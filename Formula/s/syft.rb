class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "5545ff8d797fc14d27ae23608ec271609c9038e1732ec13d4ba8042ef542f0ea"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf9affc4c537d8aa14bf29a1e62a770b6dd9998089c06685df6c39f2f7f01e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d265b4b1a6edc15068c94643bbbc1d2e6eb0d3dbecf1e6d4d5260d60329ccee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d0743ec0e7d2a56d8d2e3f0b283da09ab4419437b75c4f0a72ef4b842eebe91"
    sha256 cellar: :any_skip_relocation, sonoma:        "871356338b419287b6c81c29f4c8dc64ccd96d6213fd563493862ba2c52224f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9651ea79d697205cb9acf758298721dda02d7262328b7198fd9864bec0c2613"
    sha256 cellar: :any,                 x86_64_linux:  "22ebe527c044839feb5f28e16bfc773d7747a00b7031200a9034afb9218c02f1"
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

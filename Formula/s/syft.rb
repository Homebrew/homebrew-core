class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.42.3.tar.gz"
  sha256 "7de291a80bc8305a2d51d97247599ea7b097b0e08f08a2eafda9f2f0c3c4a200"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1838b95259189a90bfcee9a52a9f478fc792fd5ba5ca396f539d2b011a738a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "422e3ae7cac60c97dc0f37bbc558f9d30d4054c74ca2567890e3bb1d80997a1b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46d2bef3af3e39933f4c7cd735289db3a6c7421e3b77b6cae43ea60f47bd37d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a275eb830520584042f22c8d56c303faaccdfdd8e0e20013534ce97270496fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0b3bff35070a9c5081889f275326b8651e171d82576fbd7756adcd6eb29b093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d04c127eb1e54111016b3075b0803559afda635d859ecee81a191f23742af0c"
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

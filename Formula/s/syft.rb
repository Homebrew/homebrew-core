class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "822808af90626929dd7725df511a674386303482a1ddd316345066e6de09b157"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbc12e38bd9ce41d6de5791a83c5b446a9e74749456c756fed2e8bf80d29e010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ddc2c25eb0baeaa931f4dbb2815ad73e629e9b3d5e51f3286674f8da7df0f2f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "432c10558bb13e04074e5de2233118393ea574f43d4e7dd07878d87982b6fe42"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a12e2fbeb00e7afec8b3e7994d4be78e28cb1ea88df4b4e26dbd55a1714a375"
    sha256 cellar: :any_skip_relocation, ventura:        "673a9aa1cfde9d362749c4a4f35cdb4b956602e9e5561ed313d5e48947ac33fe"
    sha256 cellar: :any_skip_relocation, monterey:       "d1e8c3f5ccc2f54d6373fe748396a6a9d76245720b0609fd017a84b609d238d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad9c66c53c09485c74c3d3542eb56e269144fd0e2eeb45a4710dadc59df54173"
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

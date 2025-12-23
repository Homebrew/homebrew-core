class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "399e8b4bd1a772212f5e473a480a571bef3e7d2f55bd489cb3e6932dc62e341c"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea68ea4d64907dabe9d15cfdcac8315ffcb25df87b541838df11be4ffd57abde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc05a0620e6310de53a2f8195f863ec6890a120332700d0bc03e0255085ec63c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0462ffc41963e63f5b5d6a1ab91ff6b097f18355646fc6e67edc962db8e16acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "d45f5b29ae8f4fac5cdafa4d004dacf839b98671b6f778c05599bbe1a5ac5e34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "693483704e4218d5010edc77cfd2960a3c6248a7f39b06b7cddace1a9ed24db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bbe757a79bc3b8a182dd17554de7eec334feadba08324908bf12d0f6117263d"
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

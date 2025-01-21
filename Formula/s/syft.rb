class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.18.1.tar.gz"
  sha256 "b7237b416c523fba55e754f467608087341e41768f569110e5cd10b2e316d717"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15fb13d19efef4642a33a5f4206e984cf7d6ecd6cd6cf59f50b37b505bdad9fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39d9bde51b8df5b5d37519d7557c2cfc8145d61837250d1edf48415a39a338ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "89f4620f4532f32bc3d6def2821f67622624d1af27a21772b3cf8616426c0fb5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf60ea896bbff528c71faead38019f28bb7cf61c218817e16775a64676d93bbd"
    sha256 cellar: :any_skip_relocation, ventura:       "88a2b0a7275675d9e078ce32cb139ac26049fc7e0f8caab53433512592a2d277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db64475e4c3811f8230dd797d9f0bc6a167a557fa56a770d799e17aa4a4f1662"
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

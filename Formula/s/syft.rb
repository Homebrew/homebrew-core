class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "34a003b961c2c0e0ab89c68a3bdae651dca3ec72d57beddcc18efa86191f6bb2"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02e513e500c23bd6b3dace8c80a378e7dcdd6e7b6bc89aa0ee4b0c533e8bb299"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c19cb38cdbda10dd291d561a379973d0ad6659a398b7fa21197629e3088553c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b3f0290ac92bd2c7efb7f5cfa32340e274436acd5bfe95c963ac022b33e2c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4fabab40a119b33f456851db74c96ae88754223a1bd257b99a0c8b12b3aadff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "345d7523d5d26d1aea73c4c4e521dadbd7a0440dfc35cddffbaa2cc28924a9f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9459bd9837fd4b635cbb6190bb46ffe3819395aeb78edfa99cbea1574021beb0"
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

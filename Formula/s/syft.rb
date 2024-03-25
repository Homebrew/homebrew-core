class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "5fbc5774fce472e8331ae0619e7f1cf12fdb3b358dcc46c52f3f3a0aaeeb1d07"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88d32ea4bc578cf2460eb69d3ac9203c508e2b0d2b0dc4bce9f47164d9b79d66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "585c4036943b820b8363d22504cea374bfec2d544d1673632e0006d16a9ba3b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3bd6356f3702789d4e4dbb0b888e6a129c705b987852e75f2ba9a1792bc40c4"
    sha256 cellar: :any_skip_relocation, sonoma:         "17df572875da8430e358a60e5d5a5f177a9880030762d6c936d0a01cd42e1345"
    sha256 cellar: :any_skip_relocation, ventura:        "fafa23f24de678034538225537aab2b608a95af946729d68c2d9de62443e39c2"
    sha256 cellar: :any_skip_relocation, monterey:       "d4c4450d511556678657eeaf9378edf8b63f373e8c4c50bb1aab267ffcd55637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0eb4b8ab49dae105b74a2f69f6f12ccba211e0e3e18f1a702e4872d08b32bf93"
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

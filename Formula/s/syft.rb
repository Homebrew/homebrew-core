class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.23.1.tar.gz"
  sha256 "a3bb388a1287da5d871d3bef195fec0f4a2352b42367bbd11ac98eac731c43b0"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a1b1155f8121a3dc9cb8a1ce29146f57b7ecf1917699ead1fe9c67251e0fb42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "492a07a5865cd97b26242e6fc617f95fa2fcea414eeabf4e87cf4497ee545f45"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1dcd6091d3550c5e010eea68b95d03ac4d84b1c5fef1a64ab926c443c2b4dbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "05d5cdac594966c2f4a830f77d35c36813d8aa1946d3a5ccfa47bc3a61b03d6a"
    sha256 cellar: :any_skip_relocation, ventura:       "214abc20d71a8035b67200da1d9ed02cc04f67c0da609a646cc3e23b854a4ef0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "797a41ef86df40f5360b019ce4c3db67a02a0b9b9e454eac818a2da744b83c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5696dcf559ac10636bebad3edb12c0bc88893e53968bd62446d37e89f617c535"
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

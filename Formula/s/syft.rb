class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "7832241881e9882d742e284f7f71d1393e3ec358f1f0c14d128c3826f006bbf8"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd978cf84edd20782b3e10524e6a7b138a38b5f438f388556c57a2e523c0da2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0e97ac6c1261426f5d67135fcbfe353a7a7e49ee5d3fca1cff8548dbd349785"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0f1f92515edca1475a50b4215bcb2cb2e0c000296d83f7856900b85487444dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "b73e55e7fdbe4297ef60f5f7d71ad013e177e748e194df8c21c746d6a4c521ff"
    sha256 cellar: :any_skip_relocation, ventura:       "bc7034ac0657d948c64a895b842951cb71217ab3ed8aa536829e7179a32d5154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "177ef32208fa623f99a8d4ab7fab31158fcda05abd45e9c58f009d3aec5a0a8d"
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

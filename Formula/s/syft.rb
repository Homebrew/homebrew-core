class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v0.105.0.tar.gz"
  sha256 "775764824ae7bade612dda78ce69b9cbc9896ae1ccc35f1effd803be653d2ddd"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a22dcb8bdd0c53a81641fee9716a35d09d679231198c7fab4011829c17359502"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18949ba2da534fd64960abd5f2bf21ceea2accb30b1f62c1f2d04620e9f80b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0dc643718b60f4345382af6b5b982ae8b8e1311aff909848619107a16fecbcd"
    sha256 cellar: :any_skip_relocation, sonoma:         "78522a1adf27a3ebb24e32f15d8d7580e4677ba587d63d882b17f3c501971e85"
    sha256 cellar: :any_skip_relocation, ventura:        "5d817249af0297f2c11d580b4e1ca24e8ad662736d0e9c0d1e310be77dec16a6"
    sha256 cellar: :any_skip_relocation, monterey:       "de33121ee1eb6c660f49e61c7d8904cd871e50f898e6e4b9f60b4fe90cb9f217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "766930d825439b606c0477252a8ff31823e0e100dbdb69dbf56a0c8d72a33399"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

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

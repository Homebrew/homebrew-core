class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "6916cb0d38c4dc56efe2171bd343b4c9a9fa19a34b46ecedcd209d6e298643b6"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6cff4484ec70e0914a450c73950e676aafd4030d6d1ad1eed25d7ee2a1eccc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8933fc47328614785e87fa05a69f7a153ea657effa1f75da6c3cd124a0daa7a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbf198c58f2e2c2698eb4c0ad43d0c394e37f6f3be21f352e9ec308033f4c24"
    sha256 cellar: :any_skip_relocation, sonoma:         "b5940a72638906638966d53ffe405c613df0d3fece8dab22747e676c2e5565a1"
    sha256 cellar: :any_skip_relocation, ventura:        "262d24ca6ee6d98bcbce1396b3b01b769be3f8e9eeced686e567fcecd29a01f5"
    sha256 cellar: :any_skip_relocation, monterey:       "e4b3fbf52c9ae4f76f9d5bff1a9e4227fa5b0fb3c5e747b41eb0fd779945603e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "393b94a3d0809246c03ed18e17bdcf614c85f18b9901e72190ed8f80c5c33437"
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

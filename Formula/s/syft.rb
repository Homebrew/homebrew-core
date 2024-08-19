class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "63b393033ef93a3fd328406a8c06bd9067ccd02521edbbcb7d72afdfe3db59b0"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67d0357e091a673475a7b79071b7652aa17b456fcd495d88e3b9c935d3a4b81f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df4d49eca0740d7a0fc67846c532f0e87b7e9112dcd61a392b54ca49c8d56a84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee9814ff57c63cbaf27a7bfde3775acd617bd216bbf4bc2d7a5bd2148e5371cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac12410a65f146c31b01fd31216d060aa1a75d346001322b47d477b1c7ccb9e"
    sha256 cellar: :any_skip_relocation, ventura:        "0fbc05f21315955c5fbba8641830334267ab352447cf7737bfb0862261b8aca6"
    sha256 cellar: :any_skip_relocation, monterey:       "11908304d6790f640d0314ab75f465868782c2a7547c52d4e3d493d419a4ee2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed218c36670c01be44b44673beefe1dafc2c457849d03cbeede83ae7a215f19"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.14.1.tar.gz"
  sha256 "b9eddad3743d24681e8e2dd921f72a54b8d0d20027dd85f406b3a9f96cf006bf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00095fde3e3060a46393b399b2cbb150a5e28a8c1502039d82a99d97f7081e60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9a0043a9297a7ecd3d88134dcce23554c023bef35b7c85bc6d3c38205698be3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a23956b1521f709d871c1ae28222fc231ae38906c1026e9031f5a0c4daa159d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "83f51887b58291ffcb85da3a9f47524e0e897cce903c53434a76c5b32f91d577"
    sha256 cellar: :any_skip_relocation, ventura:       "509e095a30fa7a1b7e307eba7c936cf94538f7c3e9432712a37d4d194c197706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20f44c5585104fbf86b6c23c10deff3b5d36c1d61499800b33a409196c51e072"
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

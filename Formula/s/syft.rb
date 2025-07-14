class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.28.0.tar.gz"
  sha256 "a196337ec9d9c10d64f6c919975a9dd66a476457787b91fb0788d1a027381747"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "043fba90db8ad0a655e86eac82da16718524f7104ea03cea1122ad9fe7b39a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c269fd7639151a2b15ca886ec4793c3ac0c7d883d5918393b0ac1292be9c80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a3fd2346be61d576342155fa1e2e470532cffcaedb765a61bb8374dbea5d1725"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e8207fdb48185024a8d085ae8bf15a424cb02a49da6a972f26b71f88ea4a84a"
    sha256 cellar: :any_skip_relocation, ventura:       "2999c9d1134881d02139b39f6ff5ac1ff067855ffa1543ead1c1a9e86f60e1e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e200979918ac7a5baad42a9b384686b065f6cc71a14afe1c60fa7a7262916a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c9de979895e651683971b24b72d9e1b388118b160698ca72b0fdb7a9bb63ae38"
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

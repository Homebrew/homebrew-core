class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "c563805e4100562b7c4733f68fd45f75bca694a272853bd294076aea5977e58f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5c46c6d668794e4d1e80e1ab32918dfcc5c118dab70696f4bf23ee35ca519934"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca129cd877f09efbed3174f05b4aec3e0859edb295c40ebfd861fbaf015b68e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "defa9de917d99a3e0fc7e7c735b3767d6c71f7890dd38151cb0e7980e6f2002f"
    sha256 cellar: :any_skip_relocation, sonoma:         "387d6901b583e86adbf1fd04e13b97a7b5d21bef1095eb347215e3a811ec9ea3"
    sha256 cellar: :any_skip_relocation, ventura:        "fac6e912c730ed77062cda5496297269fc6f34fc98cb3ef2e253f1c428fbb25f"
    sha256 cellar: :any_skip_relocation, monterey:       "007954355c4ace8ed5610bb67914e3b57ae2cbf064667488311aff137b85b06f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4259e985d5ada537a049e3339aeae6bec6053bbc77b57fe27959e6d50ece80"
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

class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "a2d856f0a37a91b813b4c55578e286ec1030cde8f9091a6ac36652175d1ab445"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1faba7df40562a34738e95f193b8e1220195ea6e30c58f4b8557d54bfb98a49"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7c69ee3e4cfe4448de8595fa71332b3cb77b6f4f2212fecaeeb66a697116888"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c34e0fb80c68bcf4e86ec5b547635a1297514a44f00f72b7a9bee3bf528a617"
    sha256 cellar: :any_skip_relocation, sonoma:         "42d06f542f4897bbbb761a1ff4bd118198cab93f3600400914ec830c78900810"
    sha256 cellar: :any_skip_relocation, ventura:        "5043df5eb7609f13b1e385742aac8349393619bd28e323ca066302c92948572a"
    sha256 cellar: :any_skip_relocation, monterey:       "721fff118f8c0d0e8be9604ae9fc53cf2905f64ee2211e3758a58017e03dba8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8de36fec12092579a95e250015eb5281118dfea72f71d47c30b6097dd5631a6"
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

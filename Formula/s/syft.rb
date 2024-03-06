class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "79852b27a0665da4e41139066c009aaeae488e82fd6b465129aed5734c5ac934"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bf28b7b99fa5dc3ff08f480b03e1c734a25d09584ded78d5222dad04f31da010"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1531417e4522776a882867e63a5ca0ec12719a564af0c53dbc5653994bc8e39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a37cb1b2f3d78c7580685e0e33affe28cd4b6245f6deed42c33c1da58282243"
    sha256 cellar: :any_skip_relocation, sonoma:         "42272be27de254d1e1184a27f31236f5670d2a3b83cbc1571b1cb9e1ca3b395f"
    sha256 cellar: :any_skip_relocation, ventura:        "9df6ac4e7b17442d41fa9b5c3eca94f04781189619b0bfa0022cc6b8e18243a6"
    sha256 cellar: :any_skip_relocation, monterey:       "46838f93e9f32b09a759f9458c649f8c03cc1979e50d21066b7ef3ab470bd7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0069f5d23d9db5c725f622e07ef4723f9ee435ed4df8aab11d8b1b1d867fbd3f"
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

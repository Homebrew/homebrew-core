class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v0.99.0.tar.gz"
  sha256 "4abf63a8377c3422bb94d44ccaff0cac66c64ee74b0c4c77769360fb72a2cf71"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca2bd2115a026ecd37342e25c9360fb15b584526d0b6c5a02c18c04ca53e306a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd737d1ece031b6d2552e66a69bd39b80fea1db3bd2d7d7527293d2e49bc6dd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0e505db2a2d1c5d10b4c5f9d5f9d991b26addd5bc766909edc72d077bb6ec06"
    sha256 cellar: :any_skip_relocation, sonoma:         "be59eab98ad1e71f0b3b2c380d2012722ecf8794771a431b552f3c1d36fd9f6a"
    sha256 cellar: :any_skip_relocation, ventura:        "7399929f1bb122a8d1308e96b41878110ed599392e66ed3667ada543a1d7a181"
    sha256 cellar: :any_skip_relocation, monterey:       "c87b8f540526980edc5898db4d5f51bc14792cbfc46dc7a5837b1e737c7a7090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d6c6d34a4c3ff235122350ef666bb7f4a649bac5955f5cf2043dc1d2ba184a3"
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

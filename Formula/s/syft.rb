class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.42.4.tar.gz"
  sha256 "8e84d456e253149d0e0c5a381a1cc4121a0e169c0608c73f99eed9ea56ed036d"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bad5d8003301621eb55f372c1ccd1f5d591c8deffcfa5d0ddd91fef862b1388"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe0ef54a98cac973fff73d3c2ae023e190c2ee907055bfb9fcaac9879d9a2625"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd107a6fbac220ace5e9c66126afca7ec1ce54e1f9651a0da4386334d3b13745"
    sha256 cellar: :any_skip_relocation, sonoma:        "c606582ae500f9ddd63d94f3ea8cf858cbccf786333c6add7be3335527118604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77fb7cac8fa71c300c9a548a8b47341f9614c21bd83a24fda14e2887f35395bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e24327f7937ed44e718420fe8e5402eab6d1482a27fe0d66af780f7a02b36c2"
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

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
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

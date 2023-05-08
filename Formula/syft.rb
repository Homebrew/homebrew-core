class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.80.0",
      revision: "0f1aed447751f92dcc0165b56aa474ec9706805e"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b0a9a2e784dca991bb06b76057cba640f776c0e8e94d8f4a3574eafdd786d7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aeea92228cedebd8752f20655516b279341c7a9c524aed2ccdd247986caca615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed54ec964f4827c7d2e230e7b7cc6de26376cf99217527fdc4e075b4145c6ad"
    sha256 cellar: :any_skip_relocation, ventura:        "9d0ab19cdf4ea537601fa310ced7cd0e5eaba8c7408fc6530ad4175f5de859a2"
    sha256 cellar: :any_skip_relocation, monterey:       "10e341291d33b0c1c92f26a21140ee05f570bd9031288c627916644a08639d46"
    sha256 cellar: :any_skip_relocation, big_sur:        "95588884bbc96592f6418ca468333deedbff2b595a8f7ba7c98fc4789d80ab93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be69a399dad5d1f4c8320a197510b8ec1c10b5c97e9c995be145a6ad8a8e5395"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json" do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/anchore/syft/internal/version.version=#{version}
      -X github.com/anchore/syft/internal/version.gitCommit=#{Utils.git_head}
      -X github.com/anchore/syft/internal/version.buildDate=#{time.iso8601}
    ]

    # Building for OSX with -extldflags "-static" results in the error:
    # ld: library not found for -lcrt0.o
    # This is because static builds are only possible if all libraries
    ldflags << "-linkmode \"external\" -extldflags \"-static\"" if OS.linux?

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", "completion")
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

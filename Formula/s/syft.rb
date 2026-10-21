class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.55.0.tar.gz"
  sha256 "d402b3988cdaea74bc01763830a6e45b4a3f1ada40f8fcad7edb5b230c18f1eb"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a0b25c7ade34a7390cba4adecbfc82f58aa5ae87c8d2864dd3244ea8c43d5137"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a2f10c36466c30f13d31bb31f70237cf7d36b9002531e2d351bb3dd606768d4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9231ff2a7ca71c807922e83c917809ffe1a8c6be705cef37a53055ab71efd408"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c7fb93d8a35a14faaa9b4e4129545bb0f7fac3364a54d4a1c699674be803a128"
    sha256 cellar: :any,                 x86_64_linux:      "53691e6c708e57f021b2c53011eafec4e88d916c473fb03f34b8d663b1c8d8f3"
  end

  depends_on "go" => :build

  resource "homebrew-micronaut.cdx.json", :test do
    url "https://raw.githubusercontent.com/anchore/syft/934644232ab115b2518acdb5d240ae31aaf55989/syft/pkg/cataloger/java/test-fixtures/graalvm-sbom/micronaut.json"
    sha256 "c09171c53d83db5de5f2b9bdfada33d242ebf7ff9808ad2bd1343754406ad44e"
  end

  # `test do` block downloads a test fixture resource
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.gitCommit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/syft"

    generate_completions_from_executable(bin/"syft", shell_parameter_format: :cobra)
  end

  test do
    testpath.install resource("homebrew-micronaut.cdx.json")
    # Redirect stderr so the progress UI does not engage on the sandbox PTY and hang
    output = shell_output("#{bin}/syft convert #{testpath}/micronaut.json 2>/dev/null")
    assert_match "netty-codec-http2  4.1.73.Final  UnknownPackage", output

    assert_match version.to_s, shell_output("#{bin}/syft --version")
  end
end

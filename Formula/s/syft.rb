class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "04f03d36dd080677127ca4b00eb3189d4447d5f9a26e7746f3011c66edf7a8a5"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7da37419a24fe1d4a533843f1189e7d66cbc1e4d5c749163f1e02bc6ded04cad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e752d44b6f32fd3926f6bac703a9ce8abdf69bc1861a8092de2cf750e3aae68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cd3d7e46bd5dcad62bdde9ce21ccd3a7e7c9c6a311fadbb825aa3e3715675bf0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbd90c34dddc8debbf23497606968bec3d49b3e7a752e876408bfb0ab40ca603"
    sha256 cellar: :any,                 x86_64_linux:      "fcebf8795a3ecb39d078ef8b825f611e71613b8face9dbf83b7743be74c73ac4"
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

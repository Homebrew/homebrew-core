class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.69.0",
      revision: "b81c9805dcc9bf25dad7659fd9c2bbf7dd3f3d90"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "428c92523820952b65e38e2476d23094266d939f6e6ad305d2a19e1fdc75a54f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5040301c5758395a257f68a409de90f914fb06987476ebeb93ce5632a823a5ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bce8b0e51c20736f3d24dd13309e86a1137b55b0e77f685f887163691ce9eea0"
    sha256 cellar: :any_skip_relocation, ventura:        "6aa32fa3cf7a1bd1f86d72246a9742e3feab91a48d775c573b141f887832ecd5"
    sha256 cellar: :any_skip_relocation, monterey:       "1d92d3ea6b723b0af47fabcb0f1b5402f558f14ac06cb47bc50f979f225c93e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "78bafe1a063aa9df79bb883b44daa8d13b5aaa986f887fdd4d54da8dff8a7306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db993d5d887c2cab043aaadfa3ec90555b4b243b28833fb6bac491b01172251a"
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

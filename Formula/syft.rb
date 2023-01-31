class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft.git",
      tag:      "v0.69.1",
      revision: "1530ef354ffaf59cef6a02c949f2cdb82353954f"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "355a168bbf52801ea172bb75c08190219bd84d54f398da8bd5e50f89544ee8a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27c95e7f74af92746d01e68c832d1a21f3c16554ee3f3f216847258bcb53ae89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e0c7d8b0a81018c3ad888d07f79bfc17c26867ab121e9dd72a442b6816694ced"
    sha256 cellar: :any_skip_relocation, ventura:        "5a3e2e65e453535b5925c89e1ea8e54ce70716d4416ff1009dd6d62714e3ba42"
    sha256 cellar: :any_skip_relocation, monterey:       "6c3fdd5b7b41775bf83745052f717244a2203bb6b013b0794d139b1bb73c8699"
    sha256 cellar: :any_skip_relocation, big_sur:        "e83ccfe7af36f298e5143a0b814078647dab6838ff0b852048661d8893b76bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60d54afe4e2bc762820f184b12ec3d4dc7fa1244d6fe2691c17b2c24594586ea"
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

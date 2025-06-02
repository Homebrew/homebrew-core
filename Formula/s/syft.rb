class Syft < Formula
  desc "CLI for generating a Software Bill of Materials from container images"
  homepage "https://github.com/anchore/syft"
  url "https://github.com/anchore/syft/archive/refs/tags/v1.26.1.tar.gz"
  sha256 "cc874a5312b6b28e10dbee935b846cf086045e074c98208a644e7872f951eebf"
  license "Apache-2.0"
  head "https://github.com/anchore/syft.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f16e53fc8015c25594fd3f80903273a73770ba78f01f3d8a842a787f5986cbe1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "633dfda128fb641d7f437aec3ee56907ae9d6920bb8c95207d9ccbe3feb0c7a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd257140eef013e0853f76d5fc85c79c69b3ebee8909b7b02b7f32a30fe4974b"
    sha256 cellar: :any_skip_relocation, sonoma:        "62bb30ee03e633a56d104c88d11d54796cdc55c66a2488088772379b0ca25107"
    sha256 cellar: :any_skip_relocation, ventura:       "d6ced268b4fbeb95affcb95374d0dd493265c0cfa0702304ea712147dc146b43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b95de68070805f22b20e6338bb47f406ba06a71fbdef600ea049cda60c1707e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1833db8dab9279465ed90f57349cffe07891659d8d69d20d7edcb9b48470b492"
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

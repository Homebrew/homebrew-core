class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.20",
      revision: "4032e1a9dc75ebb46d968e52c0e0ab7e625be21c"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fbcd92f40af9744e9ba51a72afe6c7448bd0a15d00eef56d0ef97f507010fb39"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbcd92f40af9744e9ba51a72afe6c7448bd0a15d00eef56d0ef97f507010fb39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbcd92f40af9744e9ba51a72afe6c7448bd0a15d00eef56d0ef97f507010fb39"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e91bb6c67113a05cd56699bb359cf80e2f3dff41f1e0f769efd9405ae4e4696"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3eb4c0e606b6f12f78c5d49b714e5057f2c1a004e6ba3be9e990bf0b06549025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2acd601d4550badb0044bab8673684879d9a4706fa1a0ac8ad18b54f9c692103"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/gzuidhof/tygo/cmd.version=#{version}
      -X github.com/gzuidhof/tygo/cmd.commit=#{Utils.git_head}
      -X github.com/gzuidhof/tygo/cmd.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"tygo", "completion")
    pkgshare.install "examples"
  end

  test do
    (testpath/"tygo.yml").write <<~YAML
      packages:
        - path: "simple"
          type_mappings:
            time.Time: "string /* RFC3339 */"
            null.String: "null | string"
            null.Bool: "null | boolean"
            uuid.UUID: "string /* uuid */"
            uuid.NullUUID: "null | string /* uuid */"
    YAML

    system "go", "mod", "init", "simple"
    cp pkgshare/"examples/simple/simple.go", testpath
    system bin/"tygo", "--config", testpath/"tygo.yml", "generate"
    assert_match "source: simple.go", (testpath/"index.ts").read

    assert_match version.to_s, shell_output("#{bin}/tygo --version")
  end
end

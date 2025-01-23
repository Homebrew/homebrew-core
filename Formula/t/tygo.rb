class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.17",
      revision: "421f048c0ba2528d2cebe50fb8dbf3b0b5e36aac"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec71365ca25be8b0695248d573b60ed77bc5165d902049bb9842098a9097d562"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec71365ca25be8b0695248d573b60ed77bc5165d902049bb9842098a9097d562"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec71365ca25be8b0695248d573b60ed77bc5165d902049bb9842098a9097d562"
    sha256 cellar: :any_skip_relocation, sonoma:        "d931db0194cded9eeb030acc08e037599e99931611082175012c611f70de21f8"
    sha256 cellar: :any_skip_relocation, ventura:       "d931db0194cded9eeb030acc08e037599e99931611082175012c611f70de21f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a559c9e90fcf6faec5c8603121223975717d3912aa22acc252c9c326201aa89"
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

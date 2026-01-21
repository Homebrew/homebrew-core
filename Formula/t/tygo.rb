class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.20",
      revision: "4032e1a9dc75ebb46d968e52c0e0ab7e625be21c"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30489fe2f93459e58b4a614700bc44fa5291653e56da00e23a605280f6cf05a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30489fe2f93459e58b4a614700bc44fa5291653e56da00e23a605280f6cf05a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30489fe2f93459e58b4a614700bc44fa5291653e56da00e23a605280f6cf05a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a3ccb639c69fa74a0ebe7e6139ec9853c691cf826a6bb34161e88725d741d77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fdf9b24c93cd24c2ff8604011e9664dc098a6829c54044da1979fd2a937066d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184150ec271b0743c5c4b5cfe4e816c45c4611ba25eb64171006f53f7b316a8f"
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

    generate_completions_from_executable(bin/"tygo", shell_parameter_format: :cobra)
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

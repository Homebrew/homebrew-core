class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.18",
      revision: "5974386bfc9a5d403e6d61de9c67e8762c01f590"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e314c0945c7d47759b02934f9a1a3d3321de212bd62d4fae71c48a1effbd75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e314c0945c7d47759b02934f9a1a3d3321de212bd62d4fae71c48a1effbd75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "08e314c0945c7d47759b02934f9a1a3d3321de212bd62d4fae71c48a1effbd75"
    sha256 cellar: :any_skip_relocation, sonoma:        "58078f2a3fd657c1c18af1e15b6d8431de201df2cdffd66566f5d43e5897c7c0"
    sha256 cellar: :any_skip_relocation, ventura:       "58078f2a3fd657c1c18af1e15b6d8431de201df2cdffd66566f5d43e5897c7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f75998b51e4061e7b4d2c366b58b77e6914105cd2d3afbbaabbb06147646e0b"
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

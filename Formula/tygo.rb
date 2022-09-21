class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.4",
      revision: "29d8a4124314a880c4058cd670a4d96acfd208aa"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31b017cc6949dc9736a0641be1080fc2f5f8bb7512448630e663b3a42f024b72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f0eb7e35881bd983e70b00675a01e53593b30bb80c548bf88ac8c8cc04e4668"
    sha256 cellar: :any_skip_relocation, monterey:       "fc51c6ac8b9bf18f7613e699f1ff271f733b4ec319da24ffd3d5eeee9a410a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc91da0b630908079c7d3dd0e571192e462e456ea39d856728e0c32a2db84874"
    sha256 cellar: :any_skip_relocation, catalina:       "84c3da648dd1af56c149df4f187e7f285053a63306e67c0cbb0e4cf1e15794ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84f34c1a847c949db33ead1d53465cdf9f83e2b026dc626cda9f3bb2da95c3a5"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/gzuidhof/tygo/cmd.version=#{version}
      -X github.com/gzuidhof/tygo/cmd.commit=#{Utils.git_head}
      -X github.com/gzuidhof/tygo/cmd.commitDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tygo", "completion")
    pkgshare.install "examples"
  end

  test do
    (testpath/"tygo.yml").write <<~EOS
      packages:
        - path: "simple"
          type_mappings:
            time.Time: "string /* RFC3339 */"
            null.String: "null | string"
            null.Bool: "null | boolean"
            uuid.UUID: "string /* uuid */"
            uuid.NullUUID: "null | string /* uuid */"
    EOS

    system "go", "mod", "init", "simple"
    cp pkgshare/"examples/simple/simple.go", testpath
    system bin/"tygo", "--config", testpath/"tygo.yml", "generate"
    assert_match "source: simple.go", (testpath/"index.ts").read

    assert_match version.to_s, shell_output("#{bin}/tygo --version")
  end
end

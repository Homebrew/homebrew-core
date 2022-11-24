class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.4",
      revision: "29d8a4124314a880c4058cd670a4d96acfd208aa"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db9a6146935d59a4e14b84db25e5c9b1de743fb6cf8b73f65a9a30fffb00f26e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81d8d41d0e3ccabdf9415f2b96d371ae3fdbf8137a18b508747133b0bdd735f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31db2b9d86d64a8c3245eeb2302a12fc2763a624fca3142c14712596a4ed0cfc"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a82dcc17ba4edaf3c1dc01f0e9b45c437daec312e8100c2d9ef6ac1c2796e7"
    sha256 cellar: :any_skip_relocation, monterey:       "a85c0d826da43108c7ffe8ec5d896b852a2e6d7ca53f342a1fb6eac802d33115"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e5348d1439b277e177714c93e998ecbb06c1e6db002b62165050ad477d0e8d9"
    sha256 cellar: :any_skip_relocation, catalina:       "cb290d8f8d3c84bb35efaeb845b3c463744dea71e57ffc28f39c2839860fa20b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e040393cd996a2bcb1213b0427fd3ec7abae5ec1f893394f431be0e97bfd34c"
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

class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.5",
      revision: "5ca20f4df7f4154560450a6cf976696e4d1cf356"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "788b1c0f5f0c7b86cb0092193b8a08a2c641488ba5b8428f13a19ea5cbf7062b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "788b1c0f5f0c7b86cb0092193b8a08a2c641488ba5b8428f13a19ea5cbf7062b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788b1c0f5f0c7b86cb0092193b8a08a2c641488ba5b8428f13a19ea5cbf7062b"
    sha256 cellar: :any_skip_relocation, ventura:        "8f3f74f0031597742eb5e3def14a88167e66f735cf48cfe1fa60d8454d897f62"
    sha256 cellar: :any_skip_relocation, monterey:       "8f3f74f0031597742eb5e3def14a88167e66f735cf48cfe1fa60d8454d897f62"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f3f74f0031597742eb5e3def14a88167e66f735cf48cfe1fa60d8454d897f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f34170b8825da73995176a822dff146df9113af0b621e292fb94059b31f18494"
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

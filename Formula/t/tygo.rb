class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.10",
      revision: "50c1ef0dbfa8d0b0bef09262ce981c1c38e036bd"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e59b1a21263790f668c6e6cf9c7eb745e6762efe8cbab316f5f07fe3cb5b14d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64752107f85dc88e09abaf47d3498bc0a95526a260c78be2ccec4f99009f62df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce7770f49611c1c72c7144b03530cc8d7d80623cb8689e563595740d02675496"
    sha256 cellar: :any_skip_relocation, sonoma:         "4740d2b3769e1f0401e3ec527cbe980938b6aaf651d44f36fd4eebb9b5fa0d14"
    sha256 cellar: :any_skip_relocation, ventura:        "6afc6df93bacb463fe060bc2089767f820c45957725da39eceecb196f6fdef8e"
    sha256 cellar: :any_skip_relocation, monterey:       "d30d500a1820d4de97b17b6034947f46322df5ac03ff49aa59596e7fc5bcb60d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72cae375a66f1e0c283fe4e48710b3831426543e06c4d4e08bbea13fedd7243f"
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

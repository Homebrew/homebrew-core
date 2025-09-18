class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.19",
      revision: "39a3193308d2f22ed302f81ef286eb394aecdad0"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd3b1b9b4a048d17611d43022f4a13306944d08bf4ea1c2698a70a16a4df3314"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24e755baa5f3a58505d2f3adfb074d623a9d9c7e7fe050bde251db2efbdb3f20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24e755baa5f3a58505d2f3adfb074d623a9d9c7e7fe050bde251db2efbdb3f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24e755baa5f3a58505d2f3adfb074d623a9d9c7e7fe050bde251db2efbdb3f20"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaee779ee95a066318e97f7511e1c469d66d1a3f6d15f0abf74710cf5678ca85"
    sha256 cellar: :any_skip_relocation, ventura:       "aaee779ee95a066318e97f7511e1c469d66d1a3f6d15f0abf74710cf5678ca85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8116df3dbb098c78a642fd54ac52e926a40a083d3418b4e99e33408d08ca5af"
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

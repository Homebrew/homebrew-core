class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.21",
      revision: "0b55b7f6509c82f14206cc704eb4a230ece9efe4"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d6e0ae5facaea779a8caa8e373545281381c6c489d1d59faa80f7f29291e7620"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e0ae5facaea779a8caa8e373545281381c6c489d1d59faa80f7f29291e7620"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6e0ae5facaea779a8caa8e373545281381c6c489d1d59faa80f7f29291e7620"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fe4d2012cf85e05ea22599a7bd21015598b1facfc84d87616138e7c39869e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a63d67c0d602c13917d2bb06e643c4d896dd95fb688b788bbbb4b470eae9a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "027f518b0f4829a2b3a7340652877d4157e45c28780c75b1e64a2b25f92cd016"
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

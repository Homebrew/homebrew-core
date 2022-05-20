class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.1",
      revision: "21050dae270a875f2c8edf45f2d726f4c53caff9"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "770e1e7afb9bf4e32a837f7ccf64d88ceb94b89b48688317567fceff14bf78db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eec1e42aafd271a6c34c226498feab3d69d02425e59cf28b523fe972f2b5882"
    sha256 cellar: :any_skip_relocation, monterey:       "c926fbdca852c3f5fa450d2696d4c284f1dbcf94cc66ef113ea3ee72d6460f33"
    sha256 cellar: :any_skip_relocation, big_sur:        "7412c569ffad7dee9e4d535fa4426499955627843c9a69f1581d92b7816612e0"
    sha256 cellar: :any_skip_relocation, catalina:       "4dea7e36b601be6524f3bcb5911ff1bd0cf14b64cdf41e30b673d4e0a53f6ed1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb60775c15f452e96f871ea2ea9cc09b0dec58b9d7ebbcab94d97f4d306833dc"
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

    (zsh_completion/"_tygo").write Utils.safe_popen_read(bin/"tygo", "completion", "zsh")
    (bash_completion/"tygo").write Utils.safe_popen_read(bin/"tygo", "completion", "bash")
    (fish_completion/"tygo.fish").write Utils.safe_popen_read(bin/"tygo", "completion", "fish")
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

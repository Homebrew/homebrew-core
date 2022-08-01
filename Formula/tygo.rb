class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.2",
      revision: "6921feb342328cd1c3030cfbfb8491381aad9e50"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "428d8a1c735558dcadca6904f6f313023b0e368926002a34704ed41471d559d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f8d1b3ae335d3f0129197bef6d2544bd59ca81ef503bf5e8f41d5e22ca2413a"
    sha256 cellar: :any_skip_relocation, monterey:       "16197000eda45df317605e4b519ed54e4f99ba81e5058a6d2de33ef73ed2be23"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f29308dc3637e6fc694acfbb4637a5774430dc80b59e7164185151297766bb7"
    sha256 cellar: :any_skip_relocation, catalina:       "70e8b3a59160ead7a1e29d6ce09a09348ebe118225192817b841f60f21dd23f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbea86bd611e34a3c64044cd8c05d33eef39c21bd7457038aafbaf97e69c3d3f"
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

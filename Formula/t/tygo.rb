class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.9",
      revision: "09625a843bb514dd755ac116d203d31a0580ee10"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "498a89d07f7d1dccc02274bbba86fb2f7133ad2a90103f090fbf58a06e4929da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eee5d1c8848ff465864ffa19744312cba35dd14cab23ac1f6bce4463634c91e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e25bfae7344035367efbae90ce39f5d26303bfe4094ea82d42a3f84610fd2280"
    sha256 cellar: :any_skip_relocation, ventura:        "0cd50a778baa0fab07e783f15a61ee2fb1d5fd442e752e874106bf892836b5c2"
    sha256 cellar: :any_skip_relocation, monterey:       "c23791de48e567d936da6b15920ec0a7f20bc0a826f6e25352c58e5dc0c7244f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcd424b29b89edc886c347e1eb6aade65195086d51549a5ac2f3989a5bcf9eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440365ee933522c720b35f09b4020ce161a5391bce1bce18b4a13d70e034f650"
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

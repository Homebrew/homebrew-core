class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.14",
      revision: "0287f984061d0c2c4ab00e0d6dfdddf31e4d926d"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1db5ddbe7ac3c65070839043e128c12323c9f1ca6b02d0a2d63fc576a75c5689"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897bf609ceebd6ce2761cebe9a86f01f15e31c4979ade9f216f6884520334c21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f782d68037c29462e007a02f6a5e862f6a82174eff2984e2b307472265e14352"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed3eaa715a19757fa18feec7363f72c23dd5d4248cba82f7cab4906585c54077"
    sha256 cellar: :any_skip_relocation, ventura:        "3f180ca87e6f5dd485dc4bc2551a63edfd0ac06f977b61386451fd7d5e80f70e"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9452ca55c32b1dfd8610807d12005cdcdb98b8a0cad91dcd6acb147d27c18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681f7d56871a760ff3128010419fb4ae4f590dde9108ca1a8998f588a90e45c5"
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

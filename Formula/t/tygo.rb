class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.8",
      revision: "57dbd87b4a929ba2645d86b858774fbfa751dc4c"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "897b683865549dd48d2188f976715a61927ab6155f855ac9ef713a35cdc45f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8969c7b17f9bff62e377c0a76487933199ac78c477664456df528cfb038fa6bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "268c60cd34f660636faad6223eb55d08f1c53d1a90d4d24a823b1a65514e6798"
    sha256 cellar: :any_skip_relocation, ventura:        "64f69f70140f2617c43db3ca198939fa4c712fbbc8698c014792fed078d801a3"
    sha256 cellar: :any_skip_relocation, monterey:       "77ab55a77bb5583b2cc8ea5f1ac9f48585bd72f7b54d20162c1607c004e024ef"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0ea00c3661c02c5a2cd20b3991c10f30be8a022e0647bc729690ce38374e808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd9e35fd677cf93a8c2e819d19ad8048d508f9fe272a222260632f6a1b133b5d"
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

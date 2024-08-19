class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.15",
      revision: "2986c9a038b6d5e5babb55fb78dbad96a78e89b7"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4f17c28b88367cdae42a6f18661e1e950c9437f73dc7771195d90d33b501136"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "076ab53d41892e8ec2dced7a3ed97e2f41e514dd9ff6984719566c7f8a9f3b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24d969116e753863c168efc633d263f928679f48a6a8e709d773a530c2c87ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "01b5ac6ba7c4ee07352a8230fb2aa5eb1585154b132989261942601565e4b279"
    sha256 cellar: :any_skip_relocation, ventura:        "d21753faddc09f7c031d7de8049c8647fff9fb3328aaa4339adefe04f656944f"
    sha256 cellar: :any_skip_relocation, monterey:       "f8381c7a1fe507fa4c319bb9a8210b591bdf21c6d3904abf46b1d8d02d7b86fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52890861b2fb17f60bee0b9873378d8ad07d5212218203edaeb8f4406425c99b"
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

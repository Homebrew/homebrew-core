class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.13",
      revision: "1e537aa5f15d640c781cceed3ebedd830140a146"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "923c473b1a0dfe08f39025f059383bdc6479dab8f9ce54b2e85d313d42ee407d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcb2c55876d52a217576de6cf6ec18b67d1149120dde1510c17e4fe4a7c07eae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cc5570f861c5f484ccf2ff78e019fec303471daa91129f14cc2ede45cb3f8e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d322b2791c8359263f9221d678101273232b73401aec56463ceea6be5c3b959c"
    sha256 cellar: :any_skip_relocation, ventura:        "e73e2d8c681d7a1cf645d660d9ba6fdefa865f1a98956df21bc3b85a5d05203e"
    sha256 cellar: :any_skip_relocation, monterey:       "5f184104689feb88a2e786eacb18d5b883e72ec1332ff76660086ff5dfd6a738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93ea49ae21871fdd4d1b054378fa559753f477485ffff97c62f3d01c968c8db"
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

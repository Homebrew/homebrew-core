class Tygo < Formula
  desc "Generate Typescript types from Golang source code"
  homepage "https://github.com/gzuidhof/tygo"
  url "https://github.com/gzuidhof/tygo.git",
      tag:      "v0.2.12",
      revision: "342962e8fe07318cb925af45c3f804e8c9fcb930"
  license "MIT"
  head "https://github.com/gzuidhof/tygo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "42092d205c101d16cf06a31aecacb7631ccac4dcb7991b2a44c98f5f2a46696c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4ab0c91b20f60f8e4219f21213b0dee57f15de0518ce0c921a720ac14f83e9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c48160d324aae1507977f8926b73793d24d8187956db7bb3e8d0c29cabc500b"
    sha256 cellar: :any_skip_relocation, sonoma:         "afc67b8319716cf2d9c2c926c9e8ce571a1129a27bad3f66a6fae021b66f4002"
    sha256 cellar: :any_skip_relocation, ventura:        "c3a8be13ea61814231d6eeeab278fb3cdebbf8605a973781d775a7f58a22d271"
    sha256 cellar: :any_skip_relocation, monterey:       "30a61ae311b6df843aeeb60cec1e78214b242ee5a1b71f2d4c9d7845ce7dc9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d36abf36a9be91d5d5092f3dedcddc949cb2d0042b813723bb1851f87f601a"
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

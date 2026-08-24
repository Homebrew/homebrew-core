class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "636223c5b9d9af83601ad82be5dd8788bd35b58160f4420a899e00fc82e7618d"
  license "MIT"
  head "https://github.com/syntaqx/serve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "694f3d62a09a475cf463575e41216c883f1d5f45868bf20f0389fb14f7279e88"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "694f3d62a09a475cf463575e41216c883f1d5f45868bf20f0389fb14f7279e88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694f3d62a09a475cf463575e41216c883f1d5f45868bf20f0389fb14f7279e88"
    sha256 cellar: :any_skip_relocation, sonoma:        "01a2d98989415ff686e625532b5f4401e7ca6c2ea3a38688242b5cf349d5831c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d360ec4b4bfb4027d7a4136e9d57c856876926aa044f572e55e845f1beaa1411"
    sha256 cellar: :any,                 x86_64_linux:  "95348d7e86d96da32c05c7e3c781727b4f7fbb4a868e30af2de5137b590e73c2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/serve"
  end

  test do
    (testpath/"index.html").write("<h1>serve</h1>")
    port = free_port
    pid = spawn bin/"serve", "-port", port.to_s
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end

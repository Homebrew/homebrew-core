class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.35.0.tar.gz"
  sha256 "adf260f0aa3ccc18955f9f68ce11356c8d0e3fbb0d9b9446b137430427dafb3b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b58e4ff611253884ed0e43e25c3c610e5e3b28a16b9bb0200e0e98bb4f4bceae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f87a17dcbbc6f0b5cb89f9eca07c4a7e53bd7c2fac86057b231f8d5fd23ef9a4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "74946d5a408aa4c2a8163c4cfa507b84a65abbac032d32c1f720538fe918af39"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f82cd0627276009db7cc83b543f6cfa2145f1f05ef48ff15413d5bd7f00d9fe"
    sha256 cellar: :any_skip_relocation, ventura:       "b590e6cb31e898961e9597a50ad13314eaa7f6fbd4ff2a4eb575c4eb29419efd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01cf8ae595d525edf667ee2ad54d13293c3efb055ff5e0f3cd4cee19abcfb5a2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    system bin/"static-web-server", "generate", buildpath
    bash_completion.install "completions/static-web-server.bash" => "static-web-server"
    fish_completion.install "completions/static-web-server.fish"
    zsh_completion.install "completions/_static-web-server"
    man1.install "man/static-web-server-generate.1", "man/static-web-server.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/static-web-server --version")

    (testpath/"index.html").write <<~HTML
      <html>
      <head><title>Test</title></head>
      <body><h1>Hello, Homebrew!</h1></body>
      </html>
    HTML

    port = free_port
    pid = spawn bin/"static-web-server", "--port", port.to_s, "--root", testpath.to_s
    sleep 2

    begin
      response = shell_output("curl -s http://127.0.0.1:#{port}")
      assert_match "Hello, Homebrew!", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

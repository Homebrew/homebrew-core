class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.43.0.tar.gz"
  sha256 "bc88f3bf22fceab1eb49f8a81277f4d73348849fab7376fb746607e0063f0a73"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ddd40b95c348fc5e0dc7464593862bdd2e166f21dcb2fa04f9951e1ad7f293c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce820b52ceb9d90b0558f5ec61f9d82c57126b2d0906c164b21319674b650077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72ec01a0eedb73a5860ca41a7cbae15bc59924be9230dab801d743e83a50f8a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "95df26217927ea11bd194a29c14baffdd955a0a8d915cf3d96872697436b8aff"
    sha256 cellar: :any,                 arm64_linux:   "8e43f2f995347ba82e85b244f227abee89b693ccc20a92831301a78972b91391"
    sha256 cellar: :any,                 x86_64_linux:  "5da7899b24faa8636eb7bf6edcbbcb57bc6a9dc53016e5d1c03ab5e1959394d0"
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

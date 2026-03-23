class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "d3b3f7144180b74db2a39f8a21df546e1321336b0cb85d97f6769b6235668d2b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8d4d67aea46db6829cf47730004dade62447ee46e8fc0673cdbe30825461f876"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3784279b75ecf33de2dbc0567fa0693be0c53c2830c76a3fb31a4c1b02856da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fe99bd7d0f75a1bbf3dc8f24d2f100ac38d1b3c4816fe495337ad2abb397e19"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1a179956fc23a67e2a1c16b772644c1d279716acad5b24292dd8e9ec62d7680"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "227047fa66a75193349f4d64a6fd6cc0039d3fc9124bbe1bdb78b90d7f897c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65517c28615900509d391988532e0e24c2adca1391aa75a6ca3b8aa942945628"
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

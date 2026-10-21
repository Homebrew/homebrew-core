class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "448f20b95e4a7e08fdaad372544bfa6faeeb7a37709658f80fcd81b9b8b80345"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "edd9d9301a51532517448557e7a91343a5ea6aeba07ba02b4ddb434ecd6606fa"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "50d1f756ce6b85960f631506112165e3349d46d5e4f6b1a745a434cf49a4a705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a312d81a21afe609ee6d7551abc5a25855a05da754816dbd6bdfa475651853e4"
    sha256 cellar: :any,                 arm64_linux:       "f3ce3b348aab5ada7250b7d7918f1a3ad2a881aa3a3b51280414ca014fcf8df6"
    sha256 cellar: :any,                 x86_64_linux:      "dcf5647edf810048c0775fcd41efe2b63bbf557c1b5863bab9196adec15bf917"
  end

  depends_on "rust" => :build

  # `test do` block runs a local HTTP server.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

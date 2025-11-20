class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.39.0.tar.gz"
  sha256 "da5906ed28eb47ebe6fae782b20a2f99f69c094e7885c66612e2c03d7911631a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6bed7e706fac5e570fdab10efb0e351861a58aae3be19dfcbea3184d98f25b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ded2ecd01afcd191042d1bd40742d33fcc2964ecce684ab68188cb635ff09c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "782f319b925843cb28fccd1a06719e9a06307c4b6c0a95517de69d1ae6363c79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7e32b59db5ab2196cee9d5c39705278a87f6a32d20230048655d606ea88e9ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e3a75140b7ae63370f0ae9012427dcaa863b1098d6594933634546e4668d9d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d731a512ee6e17c8fce78ee9227037fea91e6746d29c97294c48b24b52cbc797"
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

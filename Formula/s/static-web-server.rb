class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.38.1.tar.gz"
  sha256 "fce33a832f2ad3f9a96ced59e44a8aeb6c01a804e9cfe8fb9879979c27bbd5f1"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c20d7396620c5a0b054642d376d6e4146747927ceb3ed1abfa0a1a7844c846a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22139706d74b912ff271a25bf1f0b529a030d1caed48fcbc70266209db3d0951"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e2e866e5fdaad268e018e36fe90de524084d667af5340e860ed11d61bf4cbb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "13873d191a2b8a5433b2a65b6f5e3e6a2877f29dc35cde299cc30e67521f81d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9258769da06aa39b709fa01241d27dfa20affed2e0c1ee68cb3271893dbe314a"
    sha256 cellar: :any_skip_relocation, ventura:       "a9a99637f0029ff19c4157f7aa8cb4b3cbfca8f4ef614e851f933b648fb4ebf5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f01ce8d8f6b9e856ecd5da3c869c93c6476f4d9ddb61ba4ceb37f662c9c4d26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9feba99eb409aafbcdebffb3e868114776699467aca1564d5cf411c71b346f4a"
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

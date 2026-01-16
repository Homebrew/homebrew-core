class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "db6ee202a926452d278c14872083744a67ec31710db5fd71e00e551ee0955eb4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53babcbd0f6386105e3256eb1411e58d0c51541bbdff391bdc02bd0fc6899f2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "358b232d4b07b47053018ec4426e1af98368ab2ed1f68f5195c38c91d446b487"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f75ac6c75d0d6f45f8ffbd83cf0c4d9b9a3c22a04ed799415ba738f53d6c7ad2"
    sha256 cellar: :any_skip_relocation, sonoma:        "1658b9066512b26f792c5edfda1d42dded2882e88a08fef55fa1388761e14e5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5429f13380d06607e22408bba6c8f79d866b7214418e49976777caf870de526c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "908dc63b5a120b60e933b3093f4be23fd3c2a4cbc1c2e2eef93f06a5cf7bd301"
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

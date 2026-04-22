class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "7ef8ad8f22c4655979771d0e269aaf8232617b815fd5528342ecfc7061ecacb8"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "594677fdf478948ce8261391896c7b312d390799924d1b594224787fef2a899f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bb1a0088eb9ac3ba9b51bdbed850bb934d1822f68cc787afb55975106e711f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d8a8336bcfd04fd0f2eaa67b5ce84e2d7aa6336e9276efc65f7e3573c502b78"
    sha256 cellar: :any_skip_relocation, sonoma:        "fdd9af0e70135e91dc17060fdbe8576405f9b3a796d133bce733e41deca62b4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be4e4cae5cf5af104d658dcbccb42ae251b76fea007a899b0a4e71d60aef132f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a47bb0c0590b3e99e185407e7cda710f6b057f7ac66cd106c3c2804e678b2e9"
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

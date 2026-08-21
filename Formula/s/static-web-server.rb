class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "aaaab02eddb488a14f021cc29a169ed7921ef7e0fe7668f38cb281d2d04d190b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe1e725691b03bee387343f29ca89900415b76d50202d15a64be60620593b522"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca67f96e1d3abee9fce506a54af66c79f735116b95b41e81c325a38c80da32b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43c62bc5c92b0d8a872ba7a19bb565234af4f1086a057b8f0637c5d77797e2ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "77b7059a22f198f3353ea3cb2fb08bbaf6442be04ebdeac6e94d53fe807ba3d2"
    sha256 cellar: :any,                 arm64_linux:   "5cb2ed53cd8a8a79568baabcb271823aed51271af7ddda267d5ba4992a25f8af"
    sha256 cellar: :any,                 x86_64_linux:  "60c1ed165bd93fad4500cf85523e7e0a1415537c78009986ff1e3bb3887bc6e7"
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

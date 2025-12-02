class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "47e6ec28b23429cbd8d9f378895e9d38b9b71a3f3fa243cd6023b1b76466e186"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d32d6d1ba71bcdc292630dcd34c31c90306e15c3457d4ab6e661204f24ed9ac5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bde007f762619599ea0c92a7b51e81689afc239fb81ce91a9157ef554d999590"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3afc36538ace3d1a436d06083a5ca2caa852c44a0001ec89d844ac5b9599ad5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3069bc931b6c8a549652767a03b57e9dec99c30834d11e143d9f30f7a5d38179"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e0c490043a551b160654a7084c7ab282241a67452bc0012e71ebb47002de0bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c251504f9403e16ff3e20411ed7b03ad7b4c0c0a3adbeb00d6705a09a4909d4"
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

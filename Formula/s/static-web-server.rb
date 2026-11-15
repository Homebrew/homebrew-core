class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.44.2.tar.gz"
  sha256 "b6d9f670960c4127ff83c3b5cdd0bb64dd086b5b7753054c2bb650e564c95de7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c2e6b4eb4c895b010fa2f010963733965b298a5926aae476d741cf48d59c196"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "594cc151155d78b09a66f0731f086354abab1c7317b7e144b93bfb9ccfd42f91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2b102b44025a4af66a98ea34ce668df12a459a4489abcbb149d4760399b070f"
    sha256 cellar: :any,                 arm64_linux:       "f3ac9e9b119b5a8412a1a13ceba3582046dbfde58c8ac16db3e45bee65436bf7"
    sha256 cellar: :any,                 x86_64_linux:      "44e240e803e5b82beb2cc1d26d33dbea00e1bbe3cce496aae12033226a0e9b45"
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

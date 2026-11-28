class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.44.3.tar.gz"
  sha256 "15b5dafb56e8d5ae01c6bd679d47e037637dad3cd70f0470c0d42282f782c79d"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    manifest_sha256 "b82f86c56773df7b314beb0cfd7404960a06ffd67cedea5f9ddbc0bb3bfcfb75"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "892eced624496283bbeea0097e221e5853d1307238a246f8c0e2966c6cee2ee4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ac2a928dd2b8c120b5a667c920b40f8e97220d61d877d7302060f8f132079ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5f685d1f8ca530bf278a8aa059e89318330a08881293e188c4c10923af20b73e"
    sha256 cellar: :any,                 arm64_linux:       "b786cf02423b8be7a0bff9f29f979fc5650aaee0680c7a456e877ebaa429502a"
    sha256 cellar: :any,                 x86_64_linux:      "6af4037c82186654c5ddf9513fa95cc69b7d6d04dd792a64f4b0a55ed4f61f81"
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
    with_test_process(bin/"static-web-server", "--port", port.to_s, "--root", testpath.to_s) do
      sleep 2

      response = shell_output("curl -s http://127.0.0.1:#{port}")
      assert_match "Hello, Homebrew!", response
    end
  end
end

class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.36.1.tar.gz"
  sha256 "e242e21b3e4b46395bda21b351438df6b5c54b1319a41a86b52eb49ed5567a40"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "961892661d638d43440d72d12cf9d95d29e8eb9c16d3e017c9497c12ddf37641"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa3f2cdbd8fcee585015b12043d2413993e322fc234a5370fad67dcde63d607d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c188eefa1d2ef79045abdb878232b8ccaf7c922bec2ea1053ecfc97d802f61c"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a56085747d95bbe1361d9084eaac5c1cad770f136149b72b0355f15f03b701f"
    sha256 cellar: :any_skip_relocation, ventura:       "bb19099fc589fd07295b4dd3b5dbc9202f4b22216c1861396376d2ff3f5e7ac6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d412e72dc12299e27b90c30919801f7daa38cfa935b18a9155bc76a64bcefabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58a94eee1b902bc277127a9280424a47f6868a67ac51349c72df40dd0356c512"
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

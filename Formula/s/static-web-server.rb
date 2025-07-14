class StaticWebServer < Formula
  desc "High-performance and asynchronous web server for static files-serving"
  homepage "https://static-web-server.net"
  url "https://github.com/static-web-server/static-web-server/archive/refs/tags/v2.37.0.tar.gz"
  sha256 "596444e276dc912b5ae0223cad15fc9d700b66a6e466b8904175f3f7f5546b64"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/static-web-server/static-web-server.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33c01035f12a224440e10e4c38a388b2075477357f5198e0d95687fde1fc6408"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a40093bbfee6be797696287bf35382fefe00f001693cfed900c83130150e0f98"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f409c8be5f7927eb75192b87574262bd07362678e59073e945d436aa6b0cab7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "62200152cd1308edebe9104f9cb87f208c6a637572e95922882da23e67989f9e"
    sha256 cellar: :any_skip_relocation, ventura:       "95e1fa1b0dd119f293611a217297ebd50b674e10985af98faede673562a49da7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5956c6069870f8bfb67913438111ad6b22e6375c19eb1b43fd89b8433a670313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34570fcf5d3454dc89a9807cc8e32af6af8d6ccbd90f46a09fd341b196f8858f"
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

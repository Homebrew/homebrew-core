class Shell2http < Formula
  desc "Executing shell commands via HTTP server"
  homepage "https://github.com/msoap/shell2http"
  url "https://github.com/msoap/shell2http/archive/refs/tags/v1.18.0.tar.gz"
  sha256 "0182c5d5a4574f7c932172001378132d99ed9b41432d159d70e3a19ef3c29145"
  license "MIT"
  head "https://github.com/msoap/shell2http.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7893bccd6eb781ae8bfc8cfa4b91b3783293dc42d21f8f2d144c810ef1e2d10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c7893bccd6eb781ae8bfc8cfa4b91b3783293dc42d21f8f2d144c810ef1e2d10"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c7893bccd6eb781ae8bfc8cfa4b91b3783293dc42d21f8f2d144c810ef1e2d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4233b0211cc9ad306afc569bddf22f32b7c8253032ba7f12f6e1d669d2c44065"
    sha256 cellar: :any,                 x86_64_linux:      "fdff7ea8ce953346e71c6ebbf8086313735f3fa2806aec15d93c09ce7f9e88fb"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}")

    man1.install "shell2http.1"
  end

  test do
    port = free_port
    pid = spawn bin/"shell2http", "-port", port.to_s, "/echo", "echo brewtest"
    sleep 1
    output = shell_output("curl -s http://localhost:#{port}")
    assert_match "Served by shell2http/#{version}", output

    output = shell_output("curl -s http://localhost:#{port}/echo")
    assert_match "brewtest", output
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

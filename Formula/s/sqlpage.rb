class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "ec5d243878ba7675f22b3e69b6517575c3179438d9457025739e83daca7b556e"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "74da50d69bc513f1926749c501f851f3d439ae33adca8575171f0f7325de5966"
    sha256 cellar: :any, arm64_tahoe:       "23782ada5e303b79ba456726b6bf6ea130e19c7fa07f2f4a58b13e52d8f25dfb"
    sha256 cellar: :any, arm64_sequoia:     "90116e6d65501116223304dbaaa6a651aa801462a39a54943fd922a84d89735e"
    sha256 cellar: :any, arm64_linux:       "9215617e3b41772f838ef8b7ec535e3abc2c689ca3e0a7d4539303d1b03f9d5a"
    sha256 cellar: :any, x86_64_linux:      "7554594a8dd54687ad3dbb613fc6d481872b93881a3ec866fd54e4fe3e2856f0"
  end

  depends_on "node" => :build
  depends_on "rust" => :build
  depends_on "unixodbc"

  allow_network_access! :test

  def fetch
    system "npm", "ci", *std_npm_args(prefix: false)
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "npm", "run", "build"
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port

    ENV["PORT"] = port.to_s
    pid = spawn bin/"sqlpage"

    assert_match "It works", shell_output("curl --retry-connrefused --retry 4 --silent http://localhost:#{port}")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end

class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "cb5db9c6589999d9d07f19e4cd49383a59a7625bfe5ed1a7a4b2bef21afccd76"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ef202eedf083b78ec0c1b52d15176833548f0649d283ad172a8467e3c2a7d30b"
    sha256 cellar: :any, arm64_tahoe:       "00bfa750dcfdcd73cbaac031d0442ac6e40a415a5f22b1479eb60a1fb98f3dd5"
    sha256 cellar: :any, arm64_sequoia:     "a83c7cc52d4a8e60ade2b628b36b2688728677907843f9317b99e6c29b58ad8f"
    sha256 cellar: :any, arm64_linux:       "1a724509e0fac5d7573adf5f98568c7cbd81b325381e81696fa577a0c91c9a2b"
    sha256 cellar: :any, x86_64_linux:      "701dd44cd760aeb646227e3c63f8f56e8329697c0309dc1f4e151241c095097d"
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

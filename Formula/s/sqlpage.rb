class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "a20906401bab10a1b69be73ce1f51ed037d15c300f676cbafd5c6bff920fdddd"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f57f5183e8d46a9f1c4d9ca7536968607488bda05286be6ab9d2bd7ecd2dcf68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "833e8a86a69bc2642e1cfb85f55cbbfd7415c24eaf3a5c59b77e1142d326791c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6eab17777ad0df44d974bbc88c5100d7b9c2134262dab3ccce69ef114074513f"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf041fd61b9f5022345c8b97efdca6c7fc8826b1a3c42289e5c128af01266070"
    sha256 cellar: :any_skip_relocation, ventura:        "9fefcaebe7ffddef5ea4eac1a582a0d319292693aacea0f43ac8b9cc023f998e"
    sha256 cellar: :any_skip_relocation, monterey:       "e69a6d322690ca7fc7198e0a135a2d484fecf9c950a228028ac275bc1b1d66d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c815810a3bf6478e1a2672ff8d9a4e05e9cd4af3d2671f6b8040277aa083fc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    pid = fork do
      ENV["PORT"] = port.to_s
      exec "sqlpage"
    end
    sleep(2)
    assert_match "It works", shell_output("curl -s http://localhost:#{port}")
    Process.kill(9, pid)
  end
end

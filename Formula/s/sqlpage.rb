class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "6217976a1e7eda32cbfb25924e27e0754617f76ccbae0a3201df2b83f94879a7"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "82b2977c337ab1c8a69b0077ae1fb2d2ddadd66c8f2a377653ef7b55636f5e3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37738f96603b0cd6c86d16b7299f603c19d16d7b96f9388b3059502e59b34477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec49ff3ab105cd96e4c5613e12339bfb7e6bef7e691d8a0af240a225d509ac3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "b4aba12cec94ec174a59f852a58d9394f836188f7eef1548451e4b9072e2a5bb"
    sha256 cellar: :any_skip_relocation, ventura:        "33a683275501e17bcdc750bff6e0dac279296f6097e9fbb8f256a5108602d6b3"
    sha256 cellar: :any_skip_relocation, monterey:       "9bce4946710112685687a06310afb8da300a73fcb92f0ef13d37a4d66be62d8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2ea0b0dbeab13f6116306e8423285afa962bef358436bf3a5c7c579ab6d8e80"
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

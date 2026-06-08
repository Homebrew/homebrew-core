class Sqlpage < Formula
  desc "Web app builder using SQL queries to create dynamic webapps quickly"
  homepage "https://sql-page.com/"
  url "https://github.com/sqlpage/SQLpage/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "ac92386dc9bb9c2817454951118f589543a6d6e5d53e339983a02cecdb66fa15"
  license "MIT"
  head "https://github.com/sqlpage/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f82714fd29d4ec3430a0f50a66497b60d20030f66ef41efb826ce2d0a942578d"
    sha256 cellar: :any, arm64_sequoia: "57d6cb92ce3828267a6938232a10a8b5ccd1dd6d95ee5aa4adf6a63136e37b7b"
    sha256 cellar: :any, arm64_sonoma:  "613399cc9769e9eaf7af1159a771714fe0916e301fc7abef9283461a5c1419db"
    sha256 cellar: :any, sonoma:        "2ff9eaa499c1ba9785b9d937e07cfe33775ad05874ff1bc0a14f6ce07cd4ba88"
    sha256 cellar: :any, arm64_linux:   "9c8de5c4dda0fb502c17483cad0db5a0f0aa618b408d3e40cc414648a782d3fe"
    sha256 cellar: :any, x86_64_linux:  "e4b12a22a0cbe9dbdabf267661d474afb30332fa222834c11593b7223cf30859"
  end

  depends_on "rust" => :build
  depends_on "unixodbc"

  def install
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

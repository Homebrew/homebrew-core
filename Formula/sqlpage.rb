class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "833e01ce88f309887810ce8697f45d7b65007f840805a5536ce8dddaac6ca076"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47f25f39a018f06c2c78f791067fc487bdf588f01f40b7d87f3e11ae484824e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b94b29d2146b7d3348c218d5b83cd238f7311c853b26a35828cd911227b7b391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e489842b032ba84e3e98fcec5a4783faaec8c472a35dcc27d32f43a511388ba"
    sha256 cellar: :any_skip_relocation, ventura:        "fa3bffd95538a916018795be00859d9bb507ff073053a1cfeba4328ad8c27e26"
    sha256 cellar: :any_skip_relocation, monterey:       "8d081ad8e6d262079724d55580bf580c9c74d10c18cf93eb990a0548e2a4a72c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdcaf9ee7cdac96758b9f8c1b27d327d8891954ff2b526768a2f584dfc714d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e098ef8112c5ac3858438fface4fd9d1708c29d3a77e4596902257360381b3"
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

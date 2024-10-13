class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "a4e8a802173287f72ca302722a15c2b3b3e6614ec6664a462eefd50aa1c63e58"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1cfa3ee91122ac1f8419092cb4fe75df27b1accd256e9ae568b0f4bf84fa44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f91dc9657c49858505141db8aa475e1bca53d488a9b5f9193d11682af67593"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f131a7a815d8dd8c9ceed637755fcebf6cf3c08da28c2e0cb1cad2a56fbb38ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9dbe7dc46aaab4993837a6e09841f3259cd38a1e853b353d27dffc7fed78236"
    sha256 cellar: :any_skip_relocation, ventura:       "8bfa51b75aba59c0bd551d54ddcd011897c4ecd1e0390ecee89f953d4dd497e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2c04c6c8918d007e2d10518330741ae700694312b9c4d32eb66889c260e3262"
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

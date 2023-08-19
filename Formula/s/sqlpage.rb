class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.9.5.tar.gz"
  sha256 "e04e98ff7529e293bf441e07e79de02442fbed6909fcdef5356d8d7b30dba4c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebbbd43f190ae10321bf006378ba0f82c8b8890882fcca1daace683f91707825"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d526cb89e16c6c8dfd9d00ac38210f9b7e57caca7a2934fc9eb393b8924edd09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f21651227b1fe589cec41f445ff648a7ca714fbf854d84e524c89c10bee4e28"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0665a41925052a22452b7fe7c96c7529d7f1ba05fcdded71d4564f495c091f"
    sha256 cellar: :any_skip_relocation, monterey:       "ed31d83a14107610c81f2b162cfda760b3467932e9aed8c648fe69d3f44e8bb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b51c98fd6f804082cd1eb1f93b2294642e00750eaf1c88c86a4e06cd430660ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0639d8d1c4536b031ffc2d8879da4dc8b9396d09b0f255f71794598ca7a46737"
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

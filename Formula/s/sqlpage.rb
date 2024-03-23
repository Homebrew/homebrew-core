class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.20.1.tar.gz"
  sha256 "70230e086968d7b97d6712f8956a2d8c03cabfd734ebeb4db3e655ca6a73711a"
  license "MIT"
  head "https://github.com/lovasoa/SQLpage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29abe1d0c4fee7ba66795040e95479b9bd300ae97a774e900f3ea0341c8db894"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeb0c345d7ae7bb9946f3b680c3a1fea1ce6404203d5c6112d534bf60cbdf0e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cfff226620265ac22ea6a31e840c584f245815f646db85f937bfce0fd9e4606"
    sha256 cellar: :any_skip_relocation, sonoma:         "d424f1c75e7782354e8fab767f680a017ccae8d04cb8af05303e13d74c6a17c2"
    sha256 cellar: :any_skip_relocation, ventura:        "240a0d10ea6dd629964ab999fcebe73bb703ac702517c1e85097fe064d8dc559"
    sha256 cellar: :any_skip_relocation, monterey:       "b4f1d5df12123582f648956ce92fd4171df22e76d557c418bbb822b50894c716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b00f692a4306d65b73e5cedbdb4f23c3a98bfe65fbcd23477fba5106cb2da72"
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

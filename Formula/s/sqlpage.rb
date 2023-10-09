class Sqlpage < Formula
  desc "Web application framework, for creation of websites with simple database queries"
  homepage "https://sql.ophir.dev/"
  url "https://github.com/lovasoa/SQLpage/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "3ee7861b10c430a3fedd4b4ed99eb13f04155b061c70d45135145e14be284154"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4632f75fed8bef558bbd18f513eda462a9c3521b963661d2b309ebf4c3f1cc2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1dd5bc379f2c74eebe43838e01770910b7f28161e0305cea53b9524e5c61b42b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adea519a9a2a7606635c2433de64aa0d70c211e59d229c210c8d035e3291ae49"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd0c0da608d078c4cf79fde6469a22d1923a34e9035a6576a9852d18cc7918b1"
    sha256 cellar: :any_skip_relocation, ventura:        "58f0f8792432428a66aad56d470d8d33c3d9d233ae14964f34f0880120d7d7b5"
    sha256 cellar: :any_skip_relocation, monterey:       "af883faadaddb6666c38d93a363d2a7bb4af9dd38811ee0f10ad5cfbdc8b0738"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d9557fa981dde3dd98c573061705a59a23966947700f4e3b44afcd1d1b642e1"
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

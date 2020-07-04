class Serve < Formula
  desc "Static http server anywhere you need one"
  homepage "https://github.com/syntaqx/serve"
  url "https://github.com/syntaqx/serve/archive/v0.5.0.tar.gz"
  sha256 "fab576aa29b14dcfc45ba6e0e7e6b5284a83e873b75992399b3f5ef8d415d6ae"
  head "https://github.com/syntaqx/serve.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8cc3f01c3baafe4728f382083cce3ceca4bbe7263ae51da6fdc49c01d8fc1458" => :catalina
    sha256 "a339885f14479144ebe771f5caba2239290d89926a1a8bbbaa56751b9ef62f8f" => :mojave
    sha256 "2b1474e49ed747c67fde6ed65e404da4c4e4d2f39190995241e10e62a99cca17" => :high_sierra
    sha256 "c23f691164cbd2f96630d273215f300e1e05ad99427b63e830db52c01eb9ac08" => :sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.version=#{version}", *std_go_args, "./cmd/serve"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/serve -port #{port}"
    end
    sleep 1
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match(/200 OK/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end

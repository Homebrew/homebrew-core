class Timeout < Formula
  desc "Run a command with a time limit"
  homepage "https://github.com/leecade/timeout"
  url "https://github.com/leecade/timeout/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3118b81c191862cc2b0fcd6ce41939513b0871a76fe40a1d19e362a7529775fd"
  version "1.0.0"
  license "MIT"

  depends_on "cargo" => :build

  def install
    system "cargo", "build", "--release", "--locked"
    bin.install "target/release/timeout"
  end

  test do
    assert_match /timeout/, shell_output("#{bin}/timeout --version 2>&1")
    assert_equal "124", shell_output("#{bin}/timeout 1 sleep 2; echo $?").chomp
  end
end
class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.6.0.tar.gz"
  sha256 "0ce7b26bbc05400a835b5a06e13ef69aac90a6d93ef4b989241258494f3c967f"

  bottle do
    cellar :any_skip_relocation
    sha256 "05584a115d4b1dd939863ac2c347069618a7a2f697c70aac77b73c8afea95d0f" => :sierra
    sha256 "1fb8ee8f8a4fcf792cf41e4df57b97b93096f881e9179d1d1b6e17026079da50" => :el_capitan
    sha256 "b7705ada8a2b902a509b6d8a0e959a4e3f7511be8d881541b37a877fb4d6df5b" => :yosemite
  end

  depends_on "rust" => :build

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/watchexec"
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end

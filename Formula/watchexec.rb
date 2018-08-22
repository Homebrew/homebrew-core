class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.9.0.tar.gz"
  sha256 "64a3ade996d83facf5d5aad05667425c3c0293dd7dab82e7675af483f59275fd"

  bottle do
    sha256 "9cad2fb47c861b5d869f5817f1695a8ec637fff14fa9717f435751ba93266fb4" => :high_sierra
    sha256 "f2ada633c74f85797288543b8971e198b4ad1dd78b228aa3932be132352120fe" => :sierra
    sha256 "958b13bd21fe5276520427052887a67cab82e57ff28113020f6ccbe62de89a2d" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end

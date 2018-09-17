class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.9.2.tar.gz"
  sha256 "dcb41cf075d1f07a7274a3b1138dfc585368d1a55595424290988804b58fdb96"

  bottle do
    sha256 "48cda48ee0e5b26728764c35f1a21bb8e6cbef5aa34067deae20a48f0a8a5a68" => :mojave
    sha256 "db7cdbf5129c247378278b41f231bc88f44224134b28a0049e91eea6d5f3ee31" => :high_sierra
    sha256 "c653234a0a182b6d973211c728687485977de5740f6f6bddd474bf7429b220b7" => :sierra
    sha256 "5c8b4d95cdabf5136cc74e564e10b0bea7975e36b197126a73ed88c46006871b" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -- echo 'saw file change'")
    sleep 0.1
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end

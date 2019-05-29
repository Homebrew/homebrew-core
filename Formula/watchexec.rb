class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.10.2.tar.gz"
  sha256 "ecc00e43ff2b3404ebecf9f6d0c7115f46905de07df31b573281fe4d58169869"

  bottle do
    cellar :any_skip_relocation
    sha256 "b8f31ade640fe036bab0b7d246195b85f77d6154f5af15cdd34481e17c635ced" => :mojave
    sha256 "25793f00659f605cde2c852df2a64390fa77967329bb5a9e93c24ff8c3c2d32f" => :high_sierra
    sha256 "78a9129bea6954c9d0b0076b061bae7999e71aec29aea53712220264ccba2ac4" => :sierra
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

class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.5.tar.gz"
  sha256 "799208ae05de3888e810d856f6c9d26b97918b4d68da79997a9d043aaf7237c7"

  bottle do
    sha256 "ca79986079faef5a84c2e3625aa7be1ac92b4943cfd7eaff2cc3fd25d96024b4" => :sierra
    sha256 "eea00977494253d3cb5558d9438869ce75a13d31c82430dce08aaf7a1e227077" => :el_capitan
    sha256 "4c2e0aaeed634da13f4f6742abba97ef48e32b4a4a5977204a52c5c48c68c3a7" => :yosemite
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

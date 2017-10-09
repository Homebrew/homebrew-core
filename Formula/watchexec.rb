class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.6.tar.gz"
  sha256 "4caa882a17d3e826dca92af157382145c599ac204e9b9ea810dc309402a200e8"

  bottle do
    sha256 "6bcd0add3e66e4ddc8037a246e4109b752d16006fb5a4cf22e22b3e0ce0744a9" => :high_sierra
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

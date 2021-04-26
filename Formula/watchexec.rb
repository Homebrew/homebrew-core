class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/1.15.2.tar.gz"
  sha256 "ed756ee865fe64d852c2a29d213b022b71c956e9abb5c36112005c2da2563e8a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6d1f7198fe60bb55a278303f84c6a08cdb9aec1d9906b6d2e22ef86bacba09b2"
    sha256 cellar: :any_skip_relocation, big_sur:       "8321573d5bc6511b38c568be6d02156f5d8e8bdb1065c246de5af6851f29350a"
    sha256 cellar: :any_skip_relocation, catalina:      "62f0a852f371f224a91e377971fa98c0e80f1305a19eb015099f77a209cdfc2b"
    sha256 cellar: :any_skip_relocation, mojave:        "ec6af0281856dd128a19a7d2fc1d1fd14517eee0504bda79540a91dcbdf316b5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 1
    touch "test"
    sleep 5
    Process.kill("INT", o.pid)
    assert_match "saw file change", o.read
  end
end

class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/mattgreen/watchexec"
  url "https://github.com/mattgreen/watchexec/archive/1.8.0.tar.gz"
  sha256 "57579971a698a6f846e78358cfd5048e4baeed0bface50fe7d8f95c56beb3eef"

  bottle do
    cellar :any_skip_relocation
    sha256 "040995fd3ff1fe77c9c1090c0dcad781a01343e92d75ac048265e0ce8a17f0e7" => :sierra
    sha256 "ee41a66c3381c98549cab16c14f168836aac9d76c12afbaffb484e464485218a" => :el_capitan
    sha256 "4a1822467c3953987d92530fef11ef777776701d2650cb004ac536c4b6f42da6" => :yosemite
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

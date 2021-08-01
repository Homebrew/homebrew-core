class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.17.1.tar.gz"
  sha256 "3bc82174729628010d29c85f2d2c61cc45cef5cc729f13153b1422c8f647d33f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fae78ca10f73e1d8ee781833cc261c2b6e03edc171850d62f95f2cc260a9d407"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f0113bd03beb3085248f631fb9904d216546588ba29e6d957efb69e5e444550"
    sha256 cellar: :any_skip_relocation, catalina:      "4e366f31613625af8853315fa402d528ed89d557a9cd48eaf28c40b94da196f4"
    sha256 cellar: :any_skip_relocation, mojave:        "3c0da8f7c2b134721a9c8dd87abd59036bcc8007c25037b2420e0543772c082b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5586ec13fd7f384f32301a5a851469c6aac9670e4d95f3d492b79d8264550c7"
  end

  depends_on "rust" => :build

  def install
    cd "cli" do
      system "cargo", "install", *std_cargo_args
    end
    man1.install "doc/watchexec.1"
  end

  test do
    o = IO.popen("#{bin}/watchexec -1 --postpone -- echo 'saw file change'")
    sleep 15
    touch "test"
    sleep 15
    Process.kill("TERM", o.pid)
    assert_match "saw file change", o.read
  end
end

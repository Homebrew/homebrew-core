class Watchexec < Formula
  desc "Execute commands when watched files change"
  homepage "https://github.com/watchexec/watchexec"
  url "https://github.com/watchexec/watchexec/archive/cli-v1.20.6.tar.gz"
  sha256 "fa490944bbc8eafdc585454d27ec6f75988ce7d159db8ee1244b1fc5bbd86935"
  license "Apache-2.0"
  head "https://github.com/watchexec/watchexec.git", branch: "main"

  livecheck do
    url :stable
    regex(/^cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21307d3ab8d57b60503ccba09d4eca03a444ee6e198a60d00bd4b45f50f2a6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c037bfa1aa3a1b77bcb85abb34273ecbf5bc5f6eb9c5627c819ed6c93a72f06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "208eb02f68a5ae5b909e9e325518ca655fab05c7a601f1fb9678a5ce4f1629d7"
    sha256 cellar: :any_skip_relocation, ventura:        "45306bf636e83b1ed9761e87d2f17f1e76f4e01b5cf70ea61ee1616ea18636e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5aa3fcffdc6a394906c02e15f2bffc47fdd070d606f213b4644f926641aca4d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2fb31b6ec806304cdcea676b71c90ff488bf599caaada386187c5cbe667ec80b"
    sha256 cellar: :any_skip_relocation, catalina:       "5553d313a976a4ddf1f411686019d9afa880ce589f1aa689a21c899b19ba8772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c25f950b7c299e3ecd5f57249cb58ed8a62089fb9a106ae5d7e6aa03045fea2a"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
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

class Tsshd < Formula
  desc "UDP SSH server for trzsz-ssh (tssh) with roaming support"
  homepage "https://github.com/trzsz/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "a303c14bd5a41303d56254cfa97b93ca5025c0138a8ceb9d0d777eb715b0c1bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6403b83e9b30c8d42596f45df16ec86174ccdadb2e69c52ae8260a5429df447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6403b83e9b30c8d42596f45df16ec86174ccdadb2e69c52ae8260a5429df447"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6403b83e9b30c8d42596f45df16ec86174ccdadb2e69c52ae8260a5429df447"
    sha256 cellar: :any_skip_relocation, sonoma:        "b62a6704693a2412827cc908035603eb2c8d84c31ab8498dca2dc6eee0e5d1db"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8a3dc7d6b5f3e070448a701bffd0ce05e94a708dc4ec04b529219ec38044cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6aec72067678c7bd8bbed61dae2a76c453c8a565aabedaffda978be35daf038"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tsshd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tsshd -v")

    assert_match "KCP", shell_output("#{bin}/tsshd --kcp")
    assert_match "TCP", shell_output("#{bin}/tsshd --tcp")
    assert_match "QUIC", shell_output("#{bin}/tsshd --mtu 1200")
  end
end

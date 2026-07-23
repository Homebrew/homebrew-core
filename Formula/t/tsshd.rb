class Tsshd < Formula
  desc "UDP-based SSH server with roaming support"
  homepage "https://trzsz.github.io/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.9.tar.gz"
  sha256 "fdf05a2323c8cc4ecef30e5258714d1651d80206f1bc0a5a88a45d716e82bb18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f77c287527df5f703cb15528a108d187302250e72ca4b91f97f9ef32c1d7ba9e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f77c287527df5f703cb15528a108d187302250e72ca4b91f97f9ef32c1d7ba9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f77c287527df5f703cb15528a108d187302250e72ca4b91f97f9ef32c1d7ba9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8878152451bb39054a6bb6ebdca95e518991b4c54c40f27a078c4406058f24c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bcbefe58e929be3fea5385cea1d06b8ee0c03a41452ab1afd9f53de0265ae7f"
    sha256 cellar: :any,                 x86_64_linux:  "183495229596f2905fcc1adcb1a9cda90edbcb05074d832298a2cf3c1a2fcded"
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

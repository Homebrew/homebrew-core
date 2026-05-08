class Tsshd < Formula
  desc "UDP-based SSH server with roaming support"
  homepage "https://trzsz.github.io/tsshd"
  url "https://github.com/trzsz/tsshd/archive/refs/tags/v0.1.7.tar.gz"
  sha256 "84041afef83b2bc63f288bb744f3d8473c7e257ab316b75a148767acd5e5f611"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "568d44032b2314a6b447cdcebd76d8f92a8270743a4118c6d4464a71b696255c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "568d44032b2314a6b447cdcebd76d8f92a8270743a4118c6d4464a71b696255c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "568d44032b2314a6b447cdcebd76d8f92a8270743a4118c6d4464a71b696255c"
    sha256 cellar: :any_skip_relocation, sonoma:        "464d9d5b9a40faf40b0c5879da28d1658ce8dd2188d1642dc678720a85990d40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99a25d5799bc465f174dbd0438e505648401815f82ff39e9a7c801e57d2f0a1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9279a9cf9a691a674048ccf57233ebbdca019d1a39c26fd0e3c2fe70faf25b57"
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

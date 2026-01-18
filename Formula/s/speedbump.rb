class Speedbump < Formula
  desc "TCP proxy for simulating variable, yet predictable network latency"
  homepage "https://github.com/kffl/speedbump"
  url "https://github.com/kffl/speedbump/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "ab685094e2e78818921adc8705ab01c8d26719d11313e99b9638b84ebae38194"
  license "Apache-2.0"
  head "https://github.com/kffl/speedbump.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "f991bd2a54623cf73881d495c86a2d7b4bba3c5af8fae3a74d85a1bec5bb41cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "a52604fc55f69494bce2c79dfe29d9b85ad5b8828242a10358aad3d5f82dd161"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6373e8ea1a8d06a0cd3f82bac417065b98e658a47d51a0f3316909a87ce3e041"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7359cd3407540f98642026e890d0e5ab47d0eb4b6134449b24c5c8829c48b5a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7fa5b179cf1cd3f09217a2d8c09a87fba935a4c207c329fab42b45b7e6dc586"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa3e65981fbc84cf24bb5d2724f863842366d33d1a489c8386487bc866900d54"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c9913bedf3327c303880d65524548a33401ba639e09b1b08d7657ea6d6b6e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9b18929d4d11b231b45f1f6bef8eef9dcf2564ce7baab83f688817577b481c"
    sha256 cellar: :any_skip_relocation, monterey:       "c6ec49903634a0db12e85374e71e1f11239726916218e1eae07950bd5a2484c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "93ec6fcd2dd65b2203d786ae5ebe5301b421b041460e5f4e88fec54026ead594"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ae045cae2fd336d9da73e4b33eebd244a35d804c61b2a08e8742ab2f0ead585e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "653ea4f77ffba07e1cd95c4d3805709c6c15f860641faf264a38d66bcc98ed78"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    require "pty"
    port = free_port

    r, _, pid = PTY.spawn("#{bin}/speedbump --latency=100ms --port=#{port} localhost:80")
    assert_match "[INFO]  Started speedbump: port=#{port} dest=127.0.0.1:80", r.readline

    assert_match version.to_s, shell_output("#{bin}/speedbump --version 2>&1")
  ensure
    Process.kill("TERM", pid)
  end
end

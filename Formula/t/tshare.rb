class Tshare < Formula

  desc "Share files from CLI, using transfer.sh"
  homepage "https://github.com/trikko/tshare"
  url "https://github.com/trikko/tshare/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "4c37ac39b3a76acdb728875cedf01129a60444a508835de2016c897ab8aba09b"
  license "MIT"
  head "https://github.com/trikko/tshare.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "81d518e2d0fc8549456b212a575342033aac5190693f17cd891a26812fa21270"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3082003c01763ca16ff51358e5d01250ff3cf73657d021bd5f714662708d0677"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a10191cad28288d566bc4f65723d1398f18a5703821eb9880d1c04d69619d1"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6237ca8240e330aac3ee3ae595227f2eed3b3a3d846d4f74676b40479ec640"
    sha256 cellar: :any_skip_relocation, monterey:       "b88490f92a9ecb8661ec8254ea7578c62f2a9206774efa2cd00380d53b890857"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f6ff75e0dadafe852bcc9144d03e6f36af6d134d7f7d27328d45fa2e0e54ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1eb37c05c9c77589a3707efa178de28e6756ba528b9c9a5cce80f343e611d30d"
  end

  depends_on "dub" => :build
  depends_on "ldc" => :build

  link_overwrite "bin/tshare"

  def install
    system "dub", "build", "--compiler=ldc2", "--build=release"
    bin.install "tshare"
  end

  test do
    assert_match /^tshare\/[0-9.]+ \(https:\/\/github.com\/trikko\/tshare\)/, shell_output("#{bin}/tshare --version").chomp
  end

end

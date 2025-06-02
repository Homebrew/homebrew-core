class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.01.tar.gz"
  sha256 "825e5004e6455dfb5a0483d810aeaeb0c96b8d2140e30629aaacea7292751198"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dd953e77ea1a05b015db94edb4571e9a20371183817c652830bd032b2ab5829"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a0ce286da58933311c725c9b749b7610c0d2108e77ecdeb7423f9f48b0aa414"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "491920182a0e505e927b8b7bdb5a787f242b172e49308b588998ae978999ceda"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab575cd2f8ef96cb5d568f3950e767db6442830b4c57a296c3faec5aed695c4"
    sha256 cellar: :any_skip_relocation, ventura:       "78ae796c53c5790a878453a7c3f456bdf97d11b36c8f03d44034828143325de4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28db30ec557d97ecc6f09279c5ced015a8899da00052e1e4696c5cf78ba0b6c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afeb78654a7558ad9b37d3d331c4da55ecf63e97bdc60d2f7ebe52e1710433a9"
  end

  depends_on macos: :sierra

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  def install
    inreplace "Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "BASHDIR", prefix/"etc/bash_completion.d"
    end
    system "make"
    system "make", "install"
    bash_completion.install "bash-completion/stress-ng"
  end

  test do
    output = shell_output("#{bin}/stress-ng -c 1 -t 1 2>&1")
    assert_match "successful run completed", output
  end
end

class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.17.03.tar.gz"
  sha256 "3646118dcd683bf1929357e67d36c75f950e849db48f26d298b11028e78f3e7a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ce4cb31036353e37b4e6f6e7bdff36152d789fe7b7a0568d707ea5b1c97d5b3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfe252ad0b342060dad1ced1b86e0f9211711239797c0f7b184b4a6c733d77a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "428572b145fc039a3b962ddb8caf4c8e5283ed98b1651880a6969a990f806879"
    sha256 cellar: :any_skip_relocation, sonoma:         "7228de280e07d8bd80ff621f92e404e8abf7f1542c4ec6de25ce6a733daac232"
    sha256 cellar: :any_skip_relocation, ventura:        "168f0baef94fdbf7bf9ec4b66d262aa37c1ebce5aee3011802a81a2d17e39e43"
    sha256 cellar: :any_skip_relocation, monterey:       "57bffe93fa4c2a2b8dd455f327040119933e080fc67048f697358f776ea55324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09703eb1647d275b31cc100f2b3debbc3b8e06b8383d075018a867dca4ad53a6"
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

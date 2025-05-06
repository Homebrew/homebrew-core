class StressNg < Formula
  desc "Stress test a computer system in various selectable ways"
  homepage "https://wiki.ubuntu.com/Kernel/Reference/stress-ng"
  url "https://github.com/ColinIanKing/stress-ng/archive/refs/tags/V0.19.00.tar.gz"
  sha256 "7d0be69dcdad655145026f499863de01d317e87ff87acd48c3343d451540d172"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eeb8f86c69138a119955ea02ac4a2131d7d16d59acc60fcbfa26cb482c8371b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bd9cf1d8710274244d3dc5af617accb34e4162a06ffa0b67e43f3a2ebc8ebce3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "657756acc268fe67b12c1999d661c1e49242f65ae5062259b7629678becaddf8"
    sha256 cellar: :any_skip_relocation, sonoma:        "121959f0b53a85e290bc05de7e130b376c2dde01fd91a679ee665b40d5e982e1"
    sha256 cellar: :any_skip_relocation, ventura:       "9b0f23172e59e060bd111021ee40e49fd426d755098af6cd510683b669f1e8d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae0fd0afc25f28b2b3c9abca775fd33132cc03a95521dc624d5e819cd417396a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eee18f9cafd0e41741c807356cca58f786edd561f4c9a851862cec4e158da3a5"
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

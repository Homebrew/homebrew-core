class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https://github.com/mpereira/tty-solitaire"
  url "https://github.com/mpereira/tty-solitaire/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "f2b80c8d5317e67db43c1dbf3b0f5f3dfea5e826c18744562615f1b1536ae433"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "46e8d8d54feff2319e57f46b3cd015e293ddfb6e621554c253ae996463783573"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af1c2e75d43cf1cd2472ddd7f43a3b65be13d391458c749829f6ecd4361cbab6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6e0d4124e3f8a37e045611694d87d3b5a7399eb14487ce2e1b874fce96149eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8ea8909f9e522b9e6fbbbe1db5901a0f584ef25bb788099267ee6e035f84580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "91eea2f4dd14f6a81e3b3cc44fdb72916e1ae2dec5075b85136d5a224cc8d655"
    sha256 cellar: :any_skip_relocation, sonoma:         "bd8d7120a6fa59b4eac7d784785153b1ae9508b2e22399e7cacb49b23fd22e7d"
    sha256 cellar: :any_skip_relocation, ventura:        "994d065c78b8dc3eb957b1e533df8c280d2c5adbb7be126580f728bfbb6e3cdb"
    sha256 cellar: :any_skip_relocation, monterey:       "0f84c6f6c017c4db02499d375ce1d6be389d39327fb0d5f8d050a797380c705e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca5bfa5041e8870b14c3ba92e73ad2766c8edc8cf139f03e9d983fc8d9a8976f"
    sha256 cellar: :any_skip_relocation, catalina:       "b315a94abfcf02186d94a6d4e78c71fec3538a65c5cc885df5dd9245efbca51c"
    sha256 cellar: :any_skip_relocation, mojave:         "ae38452ea77edde4a1c62085e6f1703cce1f91f04f869783761fa71399c03bf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5a265fd4dae6787d2560da92701d889f8413e1f9c13955e7ce640ff8d67714e"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ttysolitaire", "-h"
  end
end

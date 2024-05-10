class Sigi < Formula
  desc "Organizing tool for terminal lovers that hate organizing"
  homepage "https://sigi-cli.org"
  url "https://github.com/sigi-cli/sigi/archive/refs/tags/v3.6.3.tar.gz"
  sha256 "8bd08b8fb372cf0bcefd45275f8a6956d0f551e9c940c8724f55770ef5b79612"
  license "GPL-2.0-only"
  head "https://github.com/sigi-cli/sigi.git", branch: "core"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a20b2b6fa2f3c796e8eaef323e8f333639e1c14d89b0b2f34938b063412226a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73a98b113bc2270b1e2dfed1e802e39b74644a0ff31f74f6934c91a9286d8a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d37e2e8b7a7de64c2f714b76d0283e64fb3c96a3e87c9036881a59f3dda30ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "a96d1eb27fb5547a3b03999c8a2739e6df473faeb35f641a810fec2aa5d1b9d0"
    sha256 cellar: :any_skip_relocation, ventura:        "b00f66958c7aeb62f02188a35d3b7df12891fe35d35d89f47abf5e220eaadfa9"
    sha256 cellar: :any_skip_relocation, monterey:       "44d9a313f1faccce3d9d2488ef96c9d3930331788b66a6ca81508d1811543550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d0ca10c639f442090a203f06f3f02db3f23d8cb2cf36e81cbc68bafaa3b9e0c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "sigi.1"
  end

  test do
    system "#{bin}/sigi", "-st", "_brew_test", "push", "Hello World"
    assert_equal "Hello World", shell_output("#{bin}/sigi -qt _brew_test pop").strip
  end
end

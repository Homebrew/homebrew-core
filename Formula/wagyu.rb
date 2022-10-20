class Wagyu < Formula
  desc "Rust library for generating cryptocurrency wallets"
  homepage "https://github.com/AleoHQ/wagyu"
  url "https://github.com/AleoHQ/wagyu/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "2458b3d49653acd5df5f3161205301646527eca9f6ee3d84c7871afa275bad9f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/AleoHQ/wagyu.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2c14c7661079d5874264f57eba98869611af37c89f8eb65b721200a4b252946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42345a553422087010c9a64ac44910b4872eda94fd1cbe4adbe8d8a3959ae0af"
    sha256 cellar: :any_skip_relocation, monterey:       "80e29f883d5202eeae50bde81d9c920daca36c4329096dc89b642242c71c4c08"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b818f64c4f18e5fc7694d89f1bc1d038a0095ede55e3a5ecec2c80a0a04fa1d"
    sha256 cellar: :any_skip_relocation, catalina:       "69e6539d7e3801aaea4cd14acd48684f703a4c1cac0f04790d3ada827daf77f9"
    sha256 cellar: :any_skip_relocation, mojave:         "0b6fd9b45280ecac2586b191303e0e643ef14c85cad06b6aca73e51e7af6ae46"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c2175413a53a69da950ca7b879afc882f2181a34cb633e823bf2a3dc29675fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ad7922038829492f1f2bea64d1be5af4443ca3f6ab5aeec4bbfe3a37d5ceb8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/wagyu", "bitcoin"
  end
end

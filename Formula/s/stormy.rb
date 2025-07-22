class Stormy < Formula
  desc "Minimal, customizable and neofetch-like weather CLI based on rainy"
  homepage "https://github.com/ashish0kumar/stormy"
  url "https://github.com/ashish0kumar/stormy/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c9eeb65dafcc34b884d4fc895ed16d748be31ba735db12b73288fd1a1a7cb62e"
  license "MIT"
  head "https://github.com/ashish0kumar/stormy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d314b00cdc8fa8dcdb90ef0da7beb3a3746e98de45169760f206cd1e4a38cb4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d314b00cdc8fa8dcdb90ef0da7beb3a3746e98de45169760f206cd1e4a38cb4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d314b00cdc8fa8dcdb90ef0da7beb3a3746e98de45169760f206cd1e4a38cb4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e3278901f34d532c07e26327ed85efbd5d2cb73fdf76a6a7b01ec0fb605170fc"
    sha256 cellar: :any_skip_relocation, ventura:       "e3278901f34d532c07e26327ed85efbd5d2cb73fdf76a6a7b01ec0fb605170fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184c94d59d49d07781675d19bf28aa7303218a91709d6ec4b53784f0a234ad54"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Weather", shell_output("#{bin}/stormy --city London")
    assert_match "Error: City must be set in the config file or via command line flags",
      shell_output("#{bin}/stormy 2>&1", 1)
  end
end

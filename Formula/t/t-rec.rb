class TRec < Formula
  desc "Blazingly fast terminal recorder that generates animated gif images for the web"
  homepage "https://github.com/sassman/t-rec-rs"
  url "https://github.com/sassman/t-rec-rs/archive/refs/tags/v0.7.6.tar.gz"
  sha256 "a261104e33d6f60a8f9fe51c2339b79875ddb5ff5b9e7de68e7e52f9d25bf19e"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f59d75dc50e5f875cda2eb5dedac0e3dd3bc39587af67c6aab3c56cbae41efe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "60f11e3b53621879f01fd84bc63c26cd3a86f66b2cd93a177f8c63f732f4996e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f66c613c2713d64447c565f01e31ac69153ebf9dcefb3c3292fa5ec92c7b96fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10e8931e0466e77574f5528464d94d78fefa4a303219341605430c0cd992441c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bedf1fd21666f526ffa3aad1196c3b7847b17734af07c984affcd2d20646ba16"
    sha256 cellar: :any_skip_relocation, sonoma:         "613a0fe4fb12ea1db11698c315130e2137ae98ad4f5a10ea7753409a4c15627f"
    sha256 cellar: :any_skip_relocation, ventura:        "b2d905a57f708846827719505b1a6c7e43f45a0e2a1e0b4112039288b64d8194"
    sha256 cellar: :any_skip_relocation, monterey:       "52275aef2850a0cac76c8fb91ce392bd29b6c494312b7f563896922bd8c78a8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1ea4ff9e0fd2f102ff606a9de2f7a851f51d518cd36cd70192fadf8d0ad2680"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d3e2cb3b655b70016073b173db82dc545abb140388880ac0ae8c205c0732a1b"
  end

  depends_on "rust" => :build
  depends_on "imagemagick"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    o = shell_output("WINDOWID=999999 #{bin}/t-rec 2>&1", 1).strip
    if OS.mac?
      assert_equal "Error: Cannot grab screenshot from CGDisplay of window id 999999", o
    else
      assert_equal "Error: Display parsing error", o
    end
  end
end

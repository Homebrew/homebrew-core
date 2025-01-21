class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://github.com/samwho/spacer/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "b8cebdebd3845843f15f0040f36b7e06398de45c721679672e7107f8b735ab54"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "782b9a6bc9ccba574bd08ceaf62308b2f6b636ca53aaf2a27755c2a9ed0c322e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "135e5e3b8a8fa19953a8ade6bcf8a3fd37c51a7c17bde18c72f0a88d863f825f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b1c69ccaf545a788876a44f8d1b67e163959d414fee5555df7cee75b876f206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84175f6eff81f8f45338eef73a0c3a5aa68e14f864a5095a755a58dc3f396106"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec5e4afca0634e64d9eba69de1395ed4a693ce635b0d75ec8cb1940efc259d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "0af7ad4cf2970f6aa2ba356316aded697df3808595ad2fd5edc0f1578a02a1c2"
    sha256 cellar: :any_skip_relocation, ventura:        "0aceb036232509b10de0121cc182f8368fff07beed2fa7a97de4c0e938883847"
    sha256 cellar: :any_skip_relocation, monterey:       "8ccbc3a40bc093c907bcbd350fe9cde5d611d8f2503d5870256cbac0c913b396"
    sha256 cellar: :any_skip_relocation, big_sur:        "60bd7a232c459e1ef79aa25e07fa0e4ea515d04a7b26d3bf7e516b66ab45b80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ef00822b7507b52f3ba709087d474fb6c017528cfea87f314271dac59e6b2b7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end

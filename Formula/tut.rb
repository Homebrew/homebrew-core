class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/1.0.34.tar.gz"
  sha256 "4340e41395cb8cf56e11f500738ef85b838dbfeddf219c988a058e4789009a69"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e62abcc12b907028ba2a3a04c0485c299c4b88201bee0a293e8dee833f1fe048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13dcacf92ce369111e69a82905b09bd5715c379e7038e96984d07b21d54cd718"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8d0b3b77fc32636414707876f730f5eab9bb80f2a31a3e87c1881e18ffe07f83"
    sha256 cellar: :any_skip_relocation, ventura:        "cfdb442154e5b053656850211c0fcd0e1c9f055025e80ba7ec2868d7e4d0f13e"
    sha256 cellar: :any_skip_relocation, monterey:       "08b6724bbcabce3afb2a5b54e4f4c85afd1f8265d1b8aa1245b62e13069d911f"
    sha256 cellar: :any_skip_relocation, big_sur:        "18099382d2b7be9251ba2ef2d1f32344ccb954a4967a461d6903bedbbb729825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518fb252f3a33c5c303c103867332c0ac3bff0ce9ef34117d2e2ecc353c0a065"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tut --version")
    assert_match "Instance:", pipe_output("#{bin}/tut --new-user 2> /dev/null")
  end
end

class Yank < Formula
  desc "Copy terminal output to clipboard"
  homepage "https://github.com/mptre/yank"
  url "https://github.com/mptre/yank/archive/v1.2.0.tar.gz"
  sha256 "c4a2f854f9e49e1df61491d3fab29ea595c7e3307394acb15f32b6d415840bce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49abc10638dad41a261428f3a0fcb87606b69a9a53818cc5171451315e89d6fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "518e0acdc9c56266b1666b5d4ef54367a8c9cd104826f0499b414d4158c540c9"
    sha256 cellar: :any_skip_relocation, monterey:       "da45aa57fed9616178ad8b489e52f20a2f5980d813c505c65933778b150eda9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "df2425ac44c54c3e55aaf835a40d2ac74663193550ea32a09f88f23490e1f7d9"
    sha256 cellar: :any_skip_relocation, catalina:       "ef4da54ce9a56a1767b44dd88df6616c147730d74f390d5a661910dddf8785a7"
    sha256 cellar: :any_skip_relocation, mojave:         "60431f02c576c640597975986ce62f9d157c49f160d7d6e23f917dc321ca8bac"
    sha256 cellar: :any_skip_relocation, high_sierra:    "b87461e809f0bebd615d4da69c31509109de8f86d07d280dab07326293cc851f"
    sha256 cellar: :any_skip_relocation, sierra:         "70a5de45249c1656653733fea8d7a92c2496b9ba8e7540eef86b3f805d0e933a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f04ce62b6e440fa687142f18f0487c52936827cadbae0eff64bd9da3484e9f8a"
  end

  uses_from_macos "expect" => :test

  def install
    system "make", "install", "PREFIX=#{prefix}", "YANKCMD=pbcopy"
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn sh
      set timeout 1
      send "echo key=value | #{bin}/yank -d = | cat"
      send "\r"
      send "\016"
      send "\r"
      expect {
            "value" { send "exit\r"; exit 0 }
            timeout { send "exit\r"; exit 1 }
      }
    EOS
    system "expect", "-f", "test.exp"
  end
end

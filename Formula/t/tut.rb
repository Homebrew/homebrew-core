class Tut < Formula
  desc "TUI for Mastodon with vim inspired keys"
  homepage "https://tut.anv.nu"
  url "https://github.com/RasmusLindroth/tut/archive/refs/tags/2.0.1.tar.gz"
  sha256 "afa8c49036461a36c091d83ef51f9a3bbd938ee78f817c6467175699a989b863"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "42b58b435946efe9b969c3b218c1f7a1786500807f93676a4d31b1680c426942"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "51d7ac8bcdb9eff188e5480de11bc29d8b0adca36c195cf3adaddd631a4db1d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36cee035f905ca3370c02f3ce18a6447a9cc10a299675001933607f80480b3f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73a5450eb16784d6c42f63e497748c837d663e796d910ac7a1a839f694d6d91a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af53e3fc39990fc439f5613e1931c24bc38d05526cebd108edcc24d298ad9f86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a32649707bb41ba0dbbda69879cc9fdfdbc7e5611399ffdebe54b9857f8e8bd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9e3f9b4605812f27a115fcc6a299a36676b99d1fedb89e06a33801c4e0ee3b8"
    sha256 cellar: :any_skip_relocation, ventura:        "bb9f6d0b46819c74ed5c2b82d85bb320153853fcb826b8637b6ca6632fc9098f"
    sha256 cellar: :any_skip_relocation, monterey:       "dc6cd4fa84bc565c7f22bab2a4d55e8c313a67ecf21978a98a40cbb7fad5e4f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "931e7398ad80e6374b97fa18da74d2973698e9ef732995347e1bd01a9ac04a8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "57654e947d5c94cdbccd46dadc822ea72599793f890f12ae8823d617443aa53a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b8f56c413f16c8c270d137048c2a2d7f2f68418f20f7a5b67c6ba2f1d18167"
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

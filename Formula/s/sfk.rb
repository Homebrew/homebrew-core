class Sfk < Formula
  desc "Command-line tools collection"
  homepage "http://stahlworks.com/dev/swiss-file-knife.html"
  url "https://downloads.sourceforge.net/project/swissfileknife/1-swissfileknife/2.0.0.0/sfk-2.0.0.tar.gz"
  version "2.0.0.0"
  sha256 "ce00a33e8ab53f1aeb62e855cbe3483d284ede73bccf2ddf8ce6ff71db0f06ba"
  license "BSD-2-Clause"

  livecheck do
    url :stable
    regex(%r{url.*?swissfileknife/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4b3f0a2993c574d2ca73d2d28f9357112389306bd5233821bdfc9b2c30587f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f88e9ff4da6bb124a48c24063c57dfd1c8a8278b1ccbf2ec60d0a4888c9f41a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "639294fcbdf1f84ada63aa6d84044546f0e6168561f55220501d9534f4867f3f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55067b379e4076306d5cc4fe8a3aa7112a6a988a3a11c1d685b8c45c0abbc36"
    sha256 cellar: :any_skip_relocation, ventura:       "a66e98068d02d33675265eb9281cb9044e27985513614d24c5fd7e2392dc1d31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f589d8c2ee53519f23911b62247742df40e68a17a2f40fd843785b736fd13f"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"sfk", "ip"
  end
end

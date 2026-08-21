class Tree < Formula
  desc "Display directories as trees (with optional color/HTML output)"
  homepage "https://oldmanprogrammer.net/source.php?dir=projects/tree"
  url "https://github.com/Old-Man-Programmer/tree/archive/refs/tags/2.3.2.tar.gz"
  sha256 "22cf32e84e3eb508d97a9e991c2c3cc006b9dcf4afed201d96311c5c57d08fcf"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1967d2ed08717f963addb249ea6b8ca11c26ecb59efba34f2860853a06bedc7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef367d0a5e74970e2f5042479fe4000a8b324ac075520c66f8457f1cb06ca668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "006880fab518e0dcab2e2c906be4378996138e370199de0898e9dffb701395a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d8db41e5e26a0ffd2b7b0df8a8e0dd43a24f458ed34e2bf16352271066fcd74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb6d74ecafcc8b6d736e538b46be79249457e6c417e18b83de65b405b8495557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b98eef11e53b024a3e9422fbeabeb6c9b13d70ea884087703e7e1536820b3c5c"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system bin/"tree", prefix
  end
end

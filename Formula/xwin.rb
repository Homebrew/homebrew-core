class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.2.8.tar.gz"
  sha256 "2cca9d2833de9f2334907e86f86b6efbdea26578fc349add8644ad195149d6f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98b977655a106bd01dbd82d84705f7e97b9096485f809c3c3be86a69dd9be6e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54e18174391607e1bc40ce7d57ee9ebbea0b315f79dcfe8181f091d9fb26731f"
    sha256 cellar: :any_skip_relocation, monterey:       "85e6ff1eaa773b4ebc38654a333f8c862b56b74ae30c42524dfce14ed969b385"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef8e89709618689f3e8e541ab5b48fccae0b25c1aaa0b3641e230592c8599924"
    sha256 cellar: :any_skip_relocation, catalina:       "4f73f26b7e9e0a8d96fe3e14a2bb70820fddc949cb06504487efe90fd50cb29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7033651cde673afd2881b327e28c4b18f11f350eca6acc35315cea8216a7a283"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_predicate testpath/".xwin-cache/splat", :exist?
  end
end

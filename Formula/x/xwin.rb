class Xwin < Formula
  desc "Microsoft CRT and Windows SDK headers and libraries loader"
  homepage "https://github.com/Jake-Shadle/xwin"
  url "https://github.com/Jake-Shadle/xwin/archive/refs/tags/0.10.0.tar.gz"
  sha256 "b9e99162096d421cb64ec703297496ad1fba185f4b1a743b2490c19bbdfa2ce9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea2ec402e94e928e85c1038b249509272510d8952fe142d2cf31ef699af34bd6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "31fe132640de7a5ba939670b4234d78743a91fc082fce95c3283a21578ae55dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bede9a47eb9d801ef267bb4f6f6348a200132785da7a2684daeac45ba8a34957"
    sha256 cellar: :any_skip_relocation, sonoma:        "11f292e964bbe84479c92792428b56bf8c2ec6be893f9fdc5fccadadbeeade43"
    sha256 cellar: :any,                 arm64_linux:   "2f5348b6c554ab360e75587bb8674dbd83fc03587857d95e4b2406855cce24a5"
    sha256 cellar: :any,                 x86_64_linux:  "f8a172a4698fffb061a17ceca8d45fc0d61433d69d482dc86e60ba770adb6829"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"xwin", "--accept-license", "splat", "--disable-symlinks"
    assert_path_exists testpath/".xwin-cache/splat"
  end
end

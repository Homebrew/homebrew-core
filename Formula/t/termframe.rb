class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "b0210b80cb56fd8e6d0b1adb8e3fab0389ce6eca737266707cac2733764325e6"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ddc7b3cd96bdce2b7bdd6c13aa671b49cf67045705ced9a5a01262c3d5548a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97bcbb0f1c9667d34efe500f8e19d09245ac7f505c516f3834bcd1a92cc5a86e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9a872033edf2195c52136ba5a38c1f022202429a589e73a7aeb55de6598c9ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6931e26ccf476cadb38029969f80a0e69e5d2e4d2b8379042218033323f95e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "742069528599c38f971da5de0d20280e0b0adb84d58f6c29487ba68e9490a7f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0143c34b297832ffe12b1091c96bee570c1ebc774b502ace875a4a819376c395"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end

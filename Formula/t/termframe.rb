class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.8.8.tar.gz"
  sha256 "da1ead7aec5b35f28325f64b4f521f1660b361e5e1386d2964ab216bcd6ccb03"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a64be29aac9c2d74d91abd868a0e73688be2b24ef884d003b5c032b1aaa9871d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6e9f66e8e72283c48d4a918304842321a4b371fa56123c20d3eaceb42ed797fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57ccb9521431b93af20832ef4fbb73a91cd890a5b87bf3049834066c7da06f7a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "6d4731be417c885a4a4fffc422a34ca77970a161d04dc0179e4fb7f5f13dd584"
    sha256 cellar: :any,                 arm64_linux:       "a5cc0b77254afabddb94b37f3f4df413380efbaaa737a96032a87befa2055364"
    sha256 cellar: :any,                 x86_64_linux:      "b9e1793eb81d4db067c57eed8258b6946bc284b6ab1726917c497d0164a5286a"
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

class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "a78e944cb0c40068b1491d651bff44df4e6bfe0a66a13e82d7042f8cae118d8e"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ff27826bfcea033e25ec06f9d18c3631b8a1dd49de0d0b57b682c4f65f7480e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7aae787eab99b9efd46b327b1dd35bc23a9f2cd2f44844d89902896de5f3ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9d162e5455f2cb3f0cc6b857628d9627679bb7340ae8a23ae3565479c823088"
    sha256 cellar: :any_skip_relocation, sonoma:        "866c5b96021b868efa6083cfcd958f48cf85094abfacd5f02a51c27dbe2231bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ab6bddfa5da97711d407daa5d0ca7ac63a7928ef5d24338696bd48eefd27a1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d355b7b49e618d28414b1d5115aef0670f1bdfff9cc9ce0f5b17f14148c1ba25"
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

class TreCommand < Formula
  desc "Tree command, improved"
  homepage "https://github.com/dduan/tre"
  url "https://github.com/dduan/tre/archive/v0.3.4.tar.gz"
  sha256 "d4526efa37280ab2450c9595cf90b72d2fbf5fdeb989a3386f24297cb5da82fc"
  license "MIT"
  head "https://github.com/dduan/tre.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "83da54c1ec093bdcf15dcae90b2b43e13b2657e0b54a7b4223a8fb2b043d1c26"
    sha256 cellar: :any_skip_relocation, big_sur:       "268c11fcd92b83f9e0d063d3874503185fc3781f12d03c2f4b37f47c4f8608ae"
    sha256 cellar: :any_skip_relocation, catalina:      "68fb625fb0215e2c5922cef0bd1655987f1543ff9b602aba0f8a5ed05802d87f"
    sha256 cellar: :any_skip_relocation, mojave:        "5d8d70e8cb16b59c6a6ad8361129dd432f31d5abbab2d6d97c11279330e1aebb"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "manual/tre.1"
  end

  test do
    (testpath/"foo.txt").write("")
    assert_match("── foo.txt", shell_output("#{bin}/tre"))
  end
end

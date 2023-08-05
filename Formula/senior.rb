class Senior < Formula
  desc "Use senior instead of asking a senior for code suggestions!"
  homepage "https://github.com/brurucy/senior"
  url "https://github.com/brurucy/senior/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "052047994a8d1bd5b911e15da5bdac7deb0c8f740fa27beba51e77c8828b6671"
  license "MIT"

  depends_on "rust" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "senior 0.1.0
"

    assert_equal expected, shell_output("#{bin}/senior --version")
  end
end

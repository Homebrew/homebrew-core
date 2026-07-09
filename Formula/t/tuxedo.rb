class Tuxedo < Formula
  desc "Fast, keyboard-driven terminal UI for todo.txt"
  homepage "https://github.com/webstonehq/tuxedo"
  url "https://github.com/webstonehq/tuxedo/archive/refs/tags/v2026.6.3.tar.gz"
  sha256 "1191eb2227360451e665a5bc01584251bc107c7979cc93439c873a35ab20ee8f"
  license "MIT"
  head "https://github.com/webstonehq/tuxedo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a17e06b2c94b03eec4adb1c69e6f57c66c20d3f9121d83fefb9745cc1441295d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9bc54acc978679afdca09b5662be0a24a6421b7fb8f0b7546e457bcf770fb8f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59621f04cd8edbe3ec6ea2d15d68c301c94847c06c46fde049f006d2b7f5d57d"
    sha256 cellar: :any_skip_relocation, sonoma:        "91bb6792bb4fbec63078f3f53d8667307b5fbfd4d822a39784f5f0e1d71b516d"
    sha256 cellar: :any,                 arm64_linux:   "c17d32b388641bb57479902c21f198bbad07e4c79b3a326833c6441888c3269a"
    sha256 cellar: :any,                 x86_64_linux:  "7e514d4729d180e6bd147c194cb4b87110ed1185bef5c83cad3f8019f47089ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"todo.txt"
    system bin/"tuxedo", "add", "Hello from Homebrew"
    assert_match "Hello from Homebrew", (testpath/"todo.txt").read

    assert_match version.to_s, shell_output("#{bin}/tuxedo --version")
  end
end

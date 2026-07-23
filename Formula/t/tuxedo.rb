class Tuxedo < Formula
  desc "Fast, keyboard-driven terminal UI for todo.txt"
  homepage "https://github.com/webstonehq/tuxedo"
  url "https://github.com/webstonehq/tuxedo/archive/refs/tags/v2026.7.1.tar.gz"
  sha256 "259d46840f29141a363248e4e07701265ee75b438e4a7709a96a689da3682934"
  license "MIT"
  head "https://github.com/webstonehq/tuxedo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6b62d4e3828552489eab810241be994d8893e6e6d9aa820d2809be0484272605"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "027f45f050cc4b910c4265f3210f8152edc5009507e2b7d52f8d2a617ed4c9e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "613af70c8a89953f3946a9ab6b6dd492567e0acc8d451401be48cca965d1ce15"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1eece9ed4a095ad413655cbce2941965ed72835f665686bcbb33b943ff9f17e"
    sha256 cellar: :any,                 arm64_linux:   "6ff7cdde8aca79b97217ae8388b53bc0637447cc00607a19512de7c80dfa97aa"
    sha256 cellar: :any,                 x86_64_linux:  "b8e485277377cf955ba1699fb82ba45eedd4a200e8a46a580b6263747e2d23db"
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

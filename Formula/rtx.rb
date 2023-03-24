class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdxcode/rtx"
  url "https://github.com/jdxcode/rtx/archive/refs/tags/v1.27.4.tar.gz"
  sha256 "7489d8199b12866a75a681efa5efcd3d1961d6ddf665b38e7d4b1cf34c0adfcd"
  license "MIT"
  head "https://github.com/jdxcode/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0af78734c50f9627b5ae3a34092f398db1b583ac1580aa16da93c00b75de4081"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "547aae363c5785f6fabc4e446fa560da1a97e6aefa54cf0414e043cdfb6c236f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6a15bdfe6e6b2a0346d3d2378e781490980ddc1e1400a3855f9814d0ab97823"
    sha256 cellar: :any_skip_relocation, ventura:        "e964d98ceab72c7e09b51a4a4ca99013c4720749ce6e8a5be5a805098a8d0abb"
    sha256 cellar: :any_skip_relocation, monterey:       "2ace824303950e0fc50cf904753bdff9f668dcc472500d19e2a53636d5acebd3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c7a6a59235ee64fa744cebeb2e82521ae0f4ba492fa4eefb2121592e40cf049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b07cf51f635258acaccf3c49ced234d7cd29a53ce8598b5b45495389fc597133"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "complete", "--shell")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end

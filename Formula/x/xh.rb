class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "3f7dc6a3c8809f57a32c9aae7a192b54e87702a65d426784c1775676eea2e67f"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf026bfa5cbc26343dc02123476e897362491bb86c77d2d82d92ccfef4f288fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d9120640e68c2d6c4259413a2b6be5bfceb05e6477de159bc9f751aa4b978644"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abe934355399d3360301f432adb9fceb41d933e0cb85d0aa45a12b386e60f8a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d804da80a06c3fa1f0702aacabb85468a0d5b3065ed749e56ecc9e869b856f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "b41325090cf596f0d66c6344abeeee23cec0fa3dc197154a2526eb59e49cf100"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427b3200809c3c8a198031d1f65354d921eb16c020560b1a862fd17c0ca43bb6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install_symlink bin/"xh" => "xhs"

    man1.install "doc/xh.1"
    bash_completion.install "completions/xh.bash" => "xh"
    fish_completion.install "completions/xh.fish"
    zsh_completion.install "completions/_xh"
  end

  test do
    hash = JSON.parse(shell_output("#{bin}/xh -I -f POST https://httpbin.org/post foo=bar"))
    assert_equal hash["form"]["foo"], "bar"
  end
end

class Termframe < Formula
  desc "Terminal output SVG screenshot tool"
  homepage "https://github.com/pamburus/termframe"
  url "https://github.com/pamburus/termframe/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "95c4328f90b829e1927db3a51a887c65a460e455d00cebb54ba2f532feba2a67"
  license "MIT"
  head "https://github.com/pamburus/termframe.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6fd534463a9eecbcb10a7feedc625576d5d115c20cfa01b9c14a50be03b8a47e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "817b5610cd2e0b543009379aa793ea916afc06004c8613d47bf07fe6d2437feb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf63a2a6eb3018ea93898cb06802cb4e828a49226cfc2989a4d7fca3037ca46c"
    sha256 cellar: :any,                 arm64_linux:       "ef23a7717619e01a9d6885fb86a16fa956134effe01fd407f1ca94dc04785bb9"
    sha256 cellar: :any,                 x86_64_linux:      "d8a6aafd2ee7660dccd5419912dac7d31ee29f8f5c4bb308e12b631bb887bc5c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # `test do` block downloads fonts.
  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"termframe", "-o", "hello.svg", "--", "echo", "Hello, World"
    assert_path_exists testpath/"hello.svg"
  end
end

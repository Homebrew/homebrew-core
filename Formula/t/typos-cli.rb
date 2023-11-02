class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.16.22.tar.gz"
  sha256 "683e711ab7fdf3c888fe8c812bd22923c63d13033e009a2432ec5763baa65ac3"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15e860f55ea22acb96b66ef35485d22d8ad4bae67a120fd5f27a699e7debe3da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "195269a9aa425e0394b600ceab13b097e3f8a3b09eb33bc99669e86456cde98a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d69ec3cb68929d5b81f2088f7af0c59bb874e93ffc80dc53ec067228b420f2e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "4eb421c403635732fe30855f0df068e7c1c7cbe26e6e060cba7b9dcf1e41a768"
    sha256 cellar: :any_skip_relocation, ventura:        "52e4dc430d9d2a286753997e14540c75007f89d52a92842de14b72549bc5ed0e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce0eb8bd3a3fad7c7ebdc781297a37046be17ff10f83942a5b360f855898cb7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ffaab1996eacaa8f4eb200e8c0e90c4e74c80f4fa72a7af204c86cea1e4a628"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end

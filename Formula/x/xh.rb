class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.26.1.tar.gz"
  sha256 "6c4822374d3b9bacfc50719ffb5653a32fd84344e50fd88b499ed8fc9e52198b"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850a6a8e6b716c68f1fba6c73918a28a7632c0a534cfec1bc821c800ab07204a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1bd10fe24ca912845be90c4e8e7dce74399185d8115b4cdd16c4d43c3823817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a956b0d3a7ac0480a1c24ecaac674e53e09f5283449515eecb072a0a23096c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5722ac465644bbaf95d3bb204ed12b10b8495a689a7a1aeea9e7259711eddef2"
    sha256 cellar: :any,                 arm64_linux:   "6fca489877c66b3b64d70fa2e9936869bed5c6c2d4220ffdb1cd837e5f02d733"
    sha256 cellar: :any,                 x86_64_linux:  "35cad9daa014b7525e46c31f892f1e64039111d66cc119d47419662733d486a0"
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
    assert_match version.to_s, shell_output("#{bin}/xh --version")
    assert_match "Accept-Encoding: gzip, deflate, br, zstd", shell_output("#{bin}/xh --offline https://httpbin.org/get")
  end
end

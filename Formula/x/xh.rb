class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.26.2.tar.gz"
  sha256 "61a88a5b3beac225b75a11d6ed32659af78db7ff29c825def0ab7f4a2906cbd7"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d0e8c1d0310e6b2a692628ece06131afcfd8ccb6bcef9bed2ca60044d073df6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4e4088d22998419a48bc55932cd4f838136c5cd96c90d21c1b5f98994d52c1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e0a28c5d06c4fe1d0413466063cca1b06a465d6ce56cf6a558c2a776b880e59"
    sha256 cellar: :any_skip_relocation, sonoma:        "72e0506b810317c1da6775841545b22aef259860663bb25951d2789b019debdf"
    sha256 cellar: :any,                 arm64_linux:   "06d4bb935ad0f0820e43f45a7bf91430d55a2c3633b8bec73f7ab463f40cf68b"
    sha256 cellar: :any,                 x86_64_linux:  "c9f7ad71ebc63d83fa4efa47cae0d47838499c1f3765135f3bdca67ed14dacbf"
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

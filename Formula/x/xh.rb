class Xh < Formula
  desc "Friendly and fast tool for sending HTTP requests"
  homepage "https://github.com/ducaale/xh"
  url "https://github.com/ducaale/xh/archive/refs/tags/v0.26.3.tar.gz"
  sha256 "8c54c7e8e878600d1a322151e0158c4fa6e6793283a45e355d0c1f87ca6d5640"
  license "MIT"
  head "https://github.com/ducaale/xh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cdfe778ca3c14fe721f7d7d16e23fb2608fd2128983ef9c4a6ffce613001dca4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e757a2ef860ddea72a59c353923a50176a73eff3fba4078b9fa92d9a50e8f78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "36e4112dd55f49239d99b491acda4a0a0f764d00deef64d3c12adaef6f97d054"
    sha256 cellar: :any,                 arm64_linux:       "a6333eae3cb87c763c1f41cd3aa688f220403671acd39aacceb637fc9b4d3152"
    sha256 cellar: :any,                 x86_64_linux:      "61b30b810b3bcc4a9e428a57ea18522cb821ad9537c686ae2312267420aeb3a1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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

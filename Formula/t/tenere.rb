class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https://github.com/pythops/tenere"
  url "https://github.com/pythops/tenere/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "3605fcdff3dbd5d153ed6126e98274994bd00ed83a2a1f5587058d75797257a8"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "394e418c603576f516051602ce4dcde40e0970374f6870788c96ab2115dddcc5"
    sha256 cellar: :any,                 arm64_sequoia: "ebe0a56a1115a368c245168f523acea3382e95ba384ebc2aa717cdaeb2e6ff90"
    sha256 cellar: :any,                 arm64_sonoma:  "54e52ab6ce214bdc60df7fb5ff5b3ff67b35e63088967a561c057d67cec3b2ef"
    sha256 cellar: :any,                 sonoma:        "0f4d5cdeaa01cf72db185cdbf9d376092cd7ebd08e1afc62b1059389b74766d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1320139ad039b5060bd4085fc819b1eff3c32a9e8ecd47c5f3dead25b615e66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4d51f8d4287fddeee124a6620602dc13716c2835b39898a7864b6a9ceb7a899"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8"
  depends_on "oniguruma"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tenere --version")
    assert_match "Can not find the openai api key", shell_output("#{bin}/tenere 2>&1", 1)
  end
end

class Tenere < Formula
  desc "TUI interface for LLMs written in Rust"
  homepage "https://github.com/pythops/tenere"
  url "https://github.com/pythops/tenere/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "3605fcdff3dbd5d153ed6126e98274994bd00ed83a2a1f5587058d75797257a8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bddcfb3d99b6ff5156f85cbd3b338ebd243570526f51d8d84c2fe3ff2a4abbaa"
    sha256 cellar: :any,                 arm64_sequoia: "0ef20facf1138986f008cd6fd4b7f0f4ee847c47f8e0f253471044d468222a14"
    sha256 cellar: :any,                 arm64_sonoma:  "0a7a2b4307ec2afb07dcb5c766c81d7a1454d3d0b668e69e4dc8de25e0f051b5"
    sha256 cellar: :any,                 arm64_ventura: "f1d6be5362295a0be1bf0e3d2c5e1a89f64f3e14521619e4ddcfef824a1f0af1"
    sha256 cellar: :any,                 sonoma:        "17cde7da4a41e034a6fa20dcbfb8db9091cd6ee05b4b7fb35ad612b3bc061be7"
    sha256 cellar: :any,                 ventura:       "3cc90383070bf3d7a567028c64914ce022e8d5a9f55c57b7119c07f512902d4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ca836b19fd554f3f8e871363dfbe25ea82ceb2016d2209c9f622d49bddbc37d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ac1b9027c10ec8262887b680068256db66ce69499ea85d2eff4d7814031e07a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.8"
  depends_on "oniguruma"

  uses_from_macos "zlib"

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

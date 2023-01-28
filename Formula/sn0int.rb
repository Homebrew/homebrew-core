class Sn0int < Formula
  desc "Semi-automatic OSINT framework and package manager"
  homepage "https://github.com/kpcyrd/sn0int"
  url "https://github.com/kpcyrd/sn0int/archive/v0.25.0.tar.gz"
  sha256 "1a0a65e22ebdea4cc9d876a794c4374354cbf4733e11427190e146d32db37d8b"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a90e8342177824675573530b191caea8aa865429c5e6f79e00a4a714709b0e93"
    sha256 cellar: :any,                 arm64_monterey: "ce8a71195896f236bb4197010c26461f7bcfb86e46844b9a11b204f44890d847"
    sha256 cellar: :any,                 arm64_big_sur:  "a5d82879dda3f8366a48cdb7d19bb1aea19f7accf774629bb62a916550e7c7cb"
    sha256 cellar: :any,                 ventura:        "698ebfde69e1fdbbbfd586e3a2ad882e678950cd7a5e47225b11fcee5dc91b7b"
    sha256 cellar: :any,                 monterey:       "061757edca3f1edbe015bf5a0d085b30d556771ae507098cebcd0bb8cf39a310"
    sha256 cellar: :any,                 big_sur:        "7958a53ef4cb65dbb8be16eee3d392698f23f29cba2d157721efc35f35c38a52"
    sha256 cellar: :any,                 catalina:       "1670ddd7b8c207c3207a9458c06632585774dd44cf9a4bd7d9601ae80718c4f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be0feebb57eb8a9e61748e38a17f0c282f6f591f273fa0f00c72aff7892d6fd1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "libsodium"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "libseccomp"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sn0int", "completions")

    system "make", "-C", "docs", "man"
    man1.install "docs/_build/man/sn0int.1"
  end

  test do
    (testpath/"true.lua").write <<~EOS
      -- Description: basic selftest
      -- Version: 0.1.0
      -- License: GPL-3.0

      function run()
          -- nothing to do here
      end
    EOS
    system bin/"sn0int", "run", "-vvxf", testpath/"true.lua"
  end
end

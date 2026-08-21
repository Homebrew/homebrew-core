class Tuxedo < Formula
  desc "Fast, keyboard-driven terminal UI for todo.txt"
  homepage "https://github.com/webstonehq/tuxedo"
  url "https://github.com/webstonehq/tuxedo/archive/refs/tags/v2026.8.1.tar.gz"
  sha256 "3135e38b61bdf12f751143b5f704ebd3b1ec6f25dd7625baeb7f7f30e56b13ea"
  license "MIT"
  head "https://github.com/webstonehq/tuxedo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "02e596e023b079e75b764569297946a78348faebb31e30fecff0f1f1669c4438"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "53450041aa8827e0c2d94989d2cccd3b3e93ab3f2552abbdd7fcaf94b9fcaabf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbfb7ffb96b4284a986cb0bf2f5e53159df0cc158a1806b193ed009ef2f321a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "65ac2f90390b1a167c73f089b0758258a68d1b367f2fde9979b955aa710feb20"
    sha256 cellar: :any,                 arm64_linux:   "0a5822a1fba2d98d2514e4684c0e3c83daeb1f481e43ee44b5e13280b12814e7"
    sha256 cellar: :any,                 x86_64_linux:  "7763235b24c20a8be648f8e54df35c12ecf26e60df7d9859cb1040fe1dd232bc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"todo.txt"
    system bin/"tuxedo", "add", "Hello from Homebrew"
    assert_match "Hello from Homebrew", (testpath/"todo.txt").read

    assert_match version.to_s, shell_output("#{bin}/tuxedo --version")
  end
end

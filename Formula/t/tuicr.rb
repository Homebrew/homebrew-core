class Tuicr < Formula
  desc "Code review TUI with vim keybindings"
  homepage "https://tuicr.dev/"
  url "https://github.com/agavra/tuicr/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "8e3d06161750b5d98ae6633de9cc47c0720fa86b6aa7afa7652b8aa3c6e85f7a"
  license "MIT"
  head "https://github.com/agavra/tuicr.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e7b2e9350a1723819c72bd22757883667adbfd24219cb904a79998fc8a31be83"
    sha256 cellar: :any, arm64_tahoe:       "caa4ed17abc7f9e7139256d0dda83c21cf9805decfab288a4931eb9bf84ac429"
    sha256 cellar: :any, arm64_sequoia:     "5ebb5a952ef058d32196ce43842073fbf3f1c721814c65bcdcaf1f25ec93fbf4"
    sha256 cellar: :any, arm64_linux:       "db0932acfa74f940bfddf788e4ee1c5ddc9603be0353e3f891d6782e6721cb1f"
    sha256 cellar: :any, x86_64_linux:      "966e096224246e0ffdab687e602e228c532e77e74d87ccab177c2906b2247005"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "test"
    system "git", "config", "user.email", "test@example.com"
    (testpath/"test.txt").write("hello world\n")
    system "git", "add", "test.txt"
    system "git", "commit", "-m", "Initial commit"

    assert_equal "[]\n", shell_output("#{bin}/tuicr review list --all")
  end
end

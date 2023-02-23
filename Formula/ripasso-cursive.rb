class RipassoCursive < Formula
  desc "Tui password manager compatible with 'pass', written in rust"
  homepage "https://github.com/cortex/ripasso"
  url "https://github.com/cortex/ripasso/archive/refs/tags/release-0.6.3.tar.gz"
  sha256 "2f43e48c3e1064bef47c89269e4797f216b7600b850f3857cfce7e9716ef8f7d"
  license "GPL-3.0-only"

  depends_on "libxcb" => :build
  depends_on "llvm" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "nettle"

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    my_cargo_args = std_cargo_args.map(&:clone)
    my_cargo_args.pop
    my_cargo_args.push("cursive")
    system "cargo", "install", "ripasso-cursive", *my_cargo_args

    man1.install "target/man-page/cursive/ripasso-cursive.1"
  end

  test do
    output = shell_output("#{bin}/ripasso-cursive -h")
    assert_match "password manager", output
  end
end

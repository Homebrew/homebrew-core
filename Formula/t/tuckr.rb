class Tuckr < Formula
  desc "Super powered replacement for GNU Stow"
  homepage "https://raphgl.github.io/Tuckr/"
  url "https://github.com/RaphGL/Tuckr/archive/refs/tags/0.12.0.tar.gz"
  sha256 "2b0e359185384bcbc0160a2074dbf4c1e8fdde98c4d1a74ccb0a5af7ec753b00"
  license "GPL-3.0-or-later"
  head "https://github.com/RaphGL/Tuckr.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tuckr status 2>&1", 2)
    assert_match "Couldn't find dotfiles directory", output
    assert_match "run `tuckr init`.", output
  end
end

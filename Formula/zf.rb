class Zf < Formula
  desc "Command-line fuzzy finder that prioritizes matches on filenames"
  homepage "https://github.com/natecraddock/zf"
  url "https://github.com/natecraddock/zf/archive/refs/tags/0.6.0.tar.gz"
  sha256 "9767ce1142933c753b749630229d10519c4c0b208f63931e43495acc632135e2"
  license "MIT"
  head "https://github.com/natecraddock/zf.git", branch: "master"

  depends_on "zig" => :build

  def install
    system "zig", "build", "-Drelease-fast=true"

    bin.install "zig-out/bin/zf"
    man1.install "doc/zf.1"
    bash_completion.install "complete/zf"
    fish_completion.install "complete/zf.fish"
    zsh_completion.install "complete/_zf"
  end

  test do
    assert_equal "zig", pipe_output("#{bin}/zf -f zg", "take\off\every\nzig").chomp
  end
end

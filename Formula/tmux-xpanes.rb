class TmuxXpanes < Formula
  desc "Ultimate terminal divider powered by tmux"
  homepage "https://github.com/greymd/tmux-xpanes"
  url "https://github.com/greymd/tmux-xpanes/archive/v2.2.1.tar.gz"
  sha256 "b0c537f078e8ba2657da8f66c9ac5b0ed31d558c55bd0fff3b7898791dee1a1e"

  depends_on "tmux" => :recommended

  def install
    bin.install Dir["bin/*"]
    man1.install Dir["man/*.1"]
  end

  test do
    system "#{bin}/xpanes", "-V"
  end
end

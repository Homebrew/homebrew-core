class TmuxXpanes < Formula
  desc "Ultimate terminal divider powered by tmux"
  homepage "https://github.com/greymd/tmux-xpanes"
  url "https://github.com/greymd/tmux-xpanes.git", :tag => "v2.2.1"
  head "https://github.com/greymd/tmux-xpanes.git", :branch => "master"
  depends_on "tmux" => :recommended

  def install
    %w[xpanes tmux-xpanes].each do |cmd|
      bin.install "bin/#{cmd}"
      man1.install "man/#{cmd}.1"
    end
  end

  test do
    system "#{bin}/xpanes", "-V"
  end
end

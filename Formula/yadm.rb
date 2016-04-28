class Yadm < Formula
  desc "Yet Another Dotfiles Manager"
  homepage "https://github.com/TheLocehiliosan/yadm"
  url "https://github.com/TheLocehiliosan/yadm/archive/1.04.tar.gz"
  sha256 "a73aa51245866ce67aeb4322a62995ebbb13f29dc35508f486819dceb534968a"

  def install
    bin.install "yadm"
    man1.install "yadm.1"
  end

  test do
    system "yadm", "version"
  end
end

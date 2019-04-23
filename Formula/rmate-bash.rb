class RmateBash < Formula
  desc "Remote TextMate 2 implemented as shell script"
  homepage "https://github.com/aurora/rmate"
  url "https://github.com/aurora/rmate.git",
      :revision => "ace81cf9402ce3b9b96afa1ca9c633d84751be75"
  version "1.0.2"
  head "https://github.com/aurora/rmate.git"

  conflicts_with "rmate", :because => "both install `rmate` scripts"

  def install
    bin.install "rmate"
  end

  test do
    system "#{bin}/rmate", "--version"
  end
end

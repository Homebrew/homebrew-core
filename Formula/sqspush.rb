class Sqspush < Formula
  desc "Simple cli command that push STDIN to your AWS SQS queue"
  homepage "https://github.com/MathieuDoyon/sqspush"
  url "https://github.com/MathieuDoyon/sqspush/releases/download/0.2.1/sqspush--darwin-amd64.tar.gz"
  sha256 "3bee332c9d6cb5f69adaad924f09234250799cdc473919e516da1bc4b1120b3c"

  head "https://github.com/MathieuDoyon/sqspush.git"

  def install
    bin.install "sqspush"
  end

  test do
    system "#{bin}/sqspush", "--help"
  end
end

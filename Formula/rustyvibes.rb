class Rustyvibes < Formula
  desc "Global mechanical keyboard sound-effects CLI tool"
  homepage "https://github.com/kb24x7/rustyvibes"
  url "https://github.com/kb24x7/rustyvibes/releases/download/v1.0.2/rustyvibes-mac.tar.gz"
  version "1.0.2"
  sha256 "8898f23dbbe7a8a56028edbfbeafef10abc090242e9163dab44e5d9352660d60"

  def install
    bin.install "rustyvibes"
  end
end

class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.15.1",
      :revision => "2e9a7243147cc73ab42d17d534745daebd054860"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "100fe747a3a525dd0d7b385f6240172faca69c5f17008fc099bab90d09e5f5cb" => :sierra
    sha256 "94f1685fde91ca52091fae19604f6e4c5ccfd1983d268b9081b5a34ea7f1a16e" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.15.3",
      :revision => "cff312365b7d18d1f7ce043f54f4bffcbdba6e70"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "56f6b891f2b17d604316f1276b379c71008ea671af09af5e31d7507f2a8761fa" => :sierra
    sha256 "2779fa79ed3a88e444637b776dc4b2e5c1b2cba841f9367c87ef5ffff561e4cf" => :el_capitan
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

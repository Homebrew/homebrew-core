class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.15.1",
      :revision => "2e9a7243147cc73ab42d17d534745daebd054860"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "5b58089734a760ecbfbecc695be1cd11f1837de56ee6db2e70421ed7b9096d71" => :sierra
    sha256 "d7236009977200bc939249fca52f5e5ccdf4440962528fc55a6b766ef753cee9" => :el_capitan
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

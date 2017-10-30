class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.18.2",
      :revision => "18e391d9b1ed5032d401015740f3c19e7937e279"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "6c2d56bdfb6da7401cb87cb86ffdc61c00698bdc3fb49907f84951581b635e8e" => :high_sierra
    sha256 "6856c6d12b6405b43330c5d0293011b3ccf95ad6cf2b10b5a369d6977d15c02f" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

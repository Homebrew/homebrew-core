class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git", :tag => "0.12.1", :revision => "4749ef6230c43d19d153cea930fc5a6d0a195ef4"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "a6f61ad8e196613cca6c78664feb87dddbaeb2d17f20413bf0f987ecf661a74e" => :el_capitan
    sha256 "3e85b793448ef31bf4c9152db440f84c27e1a08f2ad05a73c94207251ccb43cd" => :yosemite
  end

  depends_on :xcode => ["7.1", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.3",
      :revision => "7a5be36967104625147e81cdb238c6d7d2a91b7c"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "29e1cc51cf184f9f500913c2f86d55487a84e5a2a531a3785f997a21df81d57a" => :sierra
    sha256 "c037907abf7c9e05c30f790193af89b77b3274ed6272e6253c9f826796e58bb8" => :el_capitan
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

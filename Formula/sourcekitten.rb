class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.20.0",
      :revision => "b6b10419ee439167ba6f7bd928ad30754ff5eb5d"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8f7da0d293233d2cc6d1459c14ff5986d1486b5b07fd05b656a24492c0681e7" => :high_sierra
    sha256 "59c32ff602435eb43db67a9b818d1112f3d660585077231c8d5e808d566f3bbc" => :sierra
  end

  depends_on :xcode => "6.0"
  depends_on :xcode => ["9.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

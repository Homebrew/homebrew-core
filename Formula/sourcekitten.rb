class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.20.0",
      :revision => "b6b10419ee439167ba6f7bd928ad30754ff5eb5d"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "18dd6b4cf0ba1bf41858a1ba55cfdc4f289aa4dee04afa4e77b8f7cac36a235a" => :high_sierra
    sha256 "6eca1a63058245ca3fd29e42cf93f0c50271d3d363a7a2578afc27d306131938" => :sierra
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

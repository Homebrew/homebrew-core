class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.30.1",
      revision: "c0f960f72fa1e6151695074ffa696e4da6c45ce8"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c794ef5f675f19aa7d8bae43307db31914070a9cb8545a44012676f2ca447044" => :catalina
    sha256 "654be477731626a28cc48c675fb8402f9c3728c957698ca93bce5ae0d2a66c8d" => :mojave
  end

  depends_on xcode: ["10.2", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

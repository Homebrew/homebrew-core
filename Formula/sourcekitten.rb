class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.31.0",
      revision: "7f4be006fe73211b0fd9666c73dc2f2303ffa756"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3389e02d3f8e53c9d54bea61bc7a465ab870b53c76a20c92f14f80166e5c7291" => :big_sur
    sha256 "c794ef5f675f19aa7d8bae43307db31914070a9cb8545a44012676f2ca447044" => :catalina
    sha256 "654be477731626a28cc48c675fb8402f9c3728c957698ca93bce5ae0d2a66c8d" => :mojave
  end

  depends_on xcode: ["11.4", :build]
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

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
    sha256 "c3df0d66fb5d3e5c978b3e0c76b36c3c46d9f63612c99530e8cb1e9a013982b8" => :big_sur
    sha256 "28df76e8f1933869199c4d9007e66012de6c3405e8009d387500259f1a0cea8c" => :arm64_big_sur
    sha256 "f6ba3676e59393e20190e6e04d70cbfab24217109363ec24799b0dd52ba4ac70" => :catalina
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

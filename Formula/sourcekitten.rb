class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag: "0.14.1",
      revision: "78c1e3de7dc96f87fa2b50ae8e5a32d0465edc51"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "d842a88a3290e582a290a0d16bf8a6b85ae29b77273ae2ce57d2b2eba57ea5f8" => :sierra
    sha256 "d8e15390c6af9d1af4757bb2c25d0e04437726df8153761d3f06c05e1b318643" => :el_capitan
  end

  depends_on :xcode => "7.3"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

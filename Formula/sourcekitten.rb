class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.1",
      :revision => "29242081ea7d36c4f45ae4589004b9c6e1423a20"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "f3d09b40d04778de80c0df113633bb6fb4f84a8e17a08705c5e5d9f406dead38" => :sierra
    sha256 "f3ecbf8cbf53e5449e00cca7714bdbd5d622b43c3a8c052cca79b069f5ee6f44" => :el_capitan
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

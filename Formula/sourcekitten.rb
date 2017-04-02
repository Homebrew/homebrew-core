class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.0",
      :revision => "b12e1442854eb6d283a4f7e7c09f2207d1652906"
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

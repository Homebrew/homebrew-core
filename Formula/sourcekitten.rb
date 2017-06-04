class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.6",
      :revision => "91d9d5b20876da2afcbf34664bccc0bfd26088c7"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "d41ac05bc696cd9544b4f8e23453e19b569d5362f69ed6f08f419092e9f0b3e4" => :sierra
    sha256 "7d7fa5bc6ab00608e1462e19f9d803ffce382bff8f6617733c5dd88bf951d076" => :el_capitan
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

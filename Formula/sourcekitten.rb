class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.16.0",
      :revision => "a014d42cd55beb06a157a063ed8d1e6b372a73e4"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "0485133682fc6d5b8d6728cbada6486142d91dd8f82e62f97edb5a0fa4bbc105" => :sierra
    sha256 "1c920eefca5b59787b872f44b06d6bbeacb05e7e1959d31b50c6a3bb33be8fba" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

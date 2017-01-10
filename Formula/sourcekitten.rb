class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.0",
      :revision => "b12e1442854eb6d283a4f7e7c09f2207d1652906"
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

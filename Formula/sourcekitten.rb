class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.18.2",
      :revision => "18e391d9b1ed5032d401015740f3c19e7937e279"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "d9b8dcf50ef92bb9a299e6bc855e581735eb12c68dd706da7449149cc18a1282" => :high_sierra
    sha256 "4742cb810a036f6c23eb61aaffa14ea3e90e69053735afe87bae8e57cf113919" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.3", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

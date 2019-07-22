class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.24.0",
      :revision => "35c9e0e437592661a51b160d80a4feaa5d4630d1"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8496c73f6d6eedf3cc74beb12f464a0cc4f84ad03a4981b052900ce91b352c1" => :mojave
    sha256 "11c63d21f16eb3def0e1e0eb4e2b665d3f47f15a1efa6e7c7a40ec51b2c88817" => :high_sierra
  end

  depends_on :xcode => ["10.0", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

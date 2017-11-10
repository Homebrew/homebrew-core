class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.18.3",
      :revision => "81a11140e3650b4e1ae31649a8f3d05c47451f34"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "bb65f44ae77462d54bdffe25a78e0a3486a3cbc8cf72e1a7d0a4e1f444c021b9" => :high_sierra
    sha256 "d0e8933c7c12861a441b9c1c25dfcd7f93782a5cfb33eb28b1a8be2028842c5f" => :sierra
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

class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.3.tar.gz"
  sha256 "c58d28721f04b1bd294a67a49f4fddb269ca75a5af9af88ff371da1356928062"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b1556a41acc117654e666aab9a925dde73cf6d3ff3caf938ab4877604f59d2b" => :catalina
    sha256 "6005048dfa1e9eb744858c965ac0d33c316576f0eb42ba7e8cff736b1b3d2649" => :mojave
  end

  depends_on :xcode => ["11.2", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "version"
  end
end

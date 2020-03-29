class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.3.tar.gz"
  sha256 "c58d28721f04b1bd294a67a49f4fddb269ca75a5af9af88ff371da1356928062"

  bottle do
    cellar :any_skip_relocation
    sha256 "1a80593ac401257a8bd6abd50960f93d53404bc707032b8e970602db262cdd5a" => :catalina
    sha256 "3d31464ea37e9dd2421c19cbb4d36292a8cdb4d384a6910257e22536cd569c59" => :mojave
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

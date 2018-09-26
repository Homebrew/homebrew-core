class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.10.2.tar.gz"
  sha256 "b76474a09bdf45eab1d03309ad0be980dfe89676f9180739eacef0d57ec0be56"

  bottle do
    cellar :any_skip_relocation
    sha256 "6dbf501d3f737498d524288aa7b43b92adea16768b79c4deb15ffaafe61fc7a0" => :high_sierra
    sha256 "9fb37fbc0afb25c1453f7bff075bbe9770b7cedc6672719545e283954ad57787" => :sierra
  end

  depends_on :xcode => ["10.0", :build]

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Weaver uses Sourcekitten and thus, has the same sandbox issues.
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/weaver", "--version"
  end
end

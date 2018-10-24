class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.10.2.tar.gz"
  sha256 "b76474a09bdf45eab1d03309ad0be980dfe89676f9180739eacef0d57ec0be56"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e0de15700f598a412e31e505e620d57db673900a6ceb4227df1e69ccb7286c3" => :mojave
    sha256 "bd2fc8164642b46f72df35e06a0d0f9fbd64179f4ba6b59d9cf380fd0d2252de" => :high_sierra
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

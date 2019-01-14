class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.11.1.tar.gz"
  sha256 "1d39ffbc1003905120e5be3cbb362d7fdbd963e944f8d44ca21ea4c2756631bd"

  bottle do
    cellar :any_skip_relocation
    sha256 "c04574bbb8dd4ac91dc7fd68f6b2424e360042643877631aba8d91d3979fae1a" => :mojave
    sha256 "5a408783400f54f6aaa9fefd4e6c00e878b85d5b21dfd893feabfab0d413f1ee" => :high_sierra
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

class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.0.tar.gz"
  sha256 "976bc968b51e45f8840e527ca56624e7db4a9f9e620dc586e1ab01c41dd90209"

  bottle do
    cellar :any_skip_relocation
    sha256 "d4097f14c37c325dfbeb831ac68e067c5533a73d79f406c7fe8d4720d9603a42" => :catalina
    sha256 "2ee78c6b03b69ef593493210b2132150c01e43802d81459ec6c0cda4ab8554c1" => :mojave
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

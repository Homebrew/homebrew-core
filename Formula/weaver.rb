class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.6.tar.gz"
  sha256 "6efdf6572a7c20f923a5d3a04855877935f5a3843c251bb98d44876cbdcb58ee"

  bottle do
    cellar :any_skip_relocation
    sha256 "5630e345561445f6c22756261872791f5549f22f720e9bb2bc9aa04f7f5fd29d" => :catalina
    sha256 "8632b48e467b5babc05e981306da5fa833a5aa4f3df5ace635eaa781ba8a5bf2" => :mojave
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

class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/1.0.5.tar.gz"
  sha256 "376edd5cb9e839c20d09858993883c42166a932648e623e0a1b1a102a7bcd0f9"

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

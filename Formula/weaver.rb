class Weaver < Formula
  desc "Command-line tool for Weaver"
  homepage "https://github.com/scribd/Weaver"
  url "https://github.com/scribd/Weaver/archive/0.12.2.tar.gz"
  sha256 "63df2ed56df046fe0fca904e0a560840286282e46c149c7023d863e4bd0cdbc5"

  bottle do
    cellar :any_skip_relocation
    sha256 "27672bcc5f5609d0826a637fd3be2d8a2022199cd3682dc49969cc8544d71f65" => :mojave
    sha256 "b1629b78af3f48d23d914a3ebaba27cd04824bb2db2ff5f97732ef5136611141" => :high_sierra
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

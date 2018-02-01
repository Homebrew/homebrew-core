class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.19.1",
      :revision => "e06eb730499439ae32c5fbb6f72809ebec2371fd"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "2c1f279128e82dbcdad3370bc18c618cb0eec70746e80e97f49da454efded78d" => :high_sierra
    sha256 "eadf96a2b71ea0006009a6d0b0bf0a6c9329078e09e450701e1889357f096dd4" => :sierra
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["9.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.27.0",
      :revision => "356551fc513eb12ed779bb369f79cf86a3a01599"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "baf78815f4fcb4975bdef85c8e70745a57969b86fa968ca9b95249e4b4557e88" => :catalina
    sha256 "1867aab18f897432c43690271cf1017116ee1ca6a62b42315b8872c5c4d1d01d" => :mojave
  end

  depends_on :xcode => ["10.2", :build]
  depends_on :xcode => "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

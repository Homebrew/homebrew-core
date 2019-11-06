class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.26.0",
      :revision => "cc1f16acc70630d27498e81078789f5fa55d7463"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e146711c4e4f4aee8d496df4c98ee1b40a27d602cd909172d9b7ad6125e18e67" => :catalina
    sha256 "07692f222d30807e026bc5a69c1220c604a60927a505aca5c0b5c535ef0229fb" => :mojave
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

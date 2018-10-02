class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.21.2",
      :revision => "4be914be6fa49cd30b1e7ef5d32d06c037d8f469"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7cd3977188f5ed7a3ce7ef3c9bef96622d6579545f4c211ee11a39518e5f2414" => :mojave
    sha256 "5ba48e9e613cd9c21ad37f604b457726fe761f9731c4e819ca532400cddedad8" => :high_sierra
    sha256 "fc58e42b0525515e1ce2c2eaad911549ecd77407868da9149bae1e776b22070e" => :sierra
  end

  depends_on :xcode => ["9.0", :build]
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

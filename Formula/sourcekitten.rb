class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.29.0",
      :revision => "77a4dbbb477a8110eb8765e3c44c70fb4929098f"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f549273e9da69397ce4c6331025ad0f45fa6ae787b6f24fe5eaee287585f22d7" => :catalina
    sha256 "9f9a1f7086aacef4513fde429ff6378eb6bc2db10afac74f6740647e853d6f0f" => :mojave
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

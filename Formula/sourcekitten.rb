class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.15.2",
      :revision => "ac55fc247ef6d3d362bfa7710e7d157f6f54d37e"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any
    sha256 "28b0031305e67c84bae1340b60b9b6b4cc5424f1d21b817ec6c675d361b21d51" => :sierra
    sha256 "db01dd5ccae491cf82bc6f3a3edc84d6a3daf02f57843a5dd203c1920f1633d8" => :el_capitan
  end

  depends_on :xcode => "8.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

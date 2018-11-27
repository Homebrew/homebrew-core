class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag      => "0.22.0",
      :revision => "176f04295a09324673245d8ec0afcce21ace8722"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d09582559c1cb6cf756df2421ae876a9c861831ac497af07a7a88f624c51283" => :mojave
    sha256 "ee5cb10ecd32e685899842899936f012b6cef5c57ffbd8558d4328ea209d49df" => :high_sierra
    sha256 "f3173e660f1a3d10ee8c459642ffb7fdc329f15edb2c63f069671af7831aa661" => :sierra
  end

  depends_on :xcode => ["10.0", :build]
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

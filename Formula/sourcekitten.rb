class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      :tag => "0.17.1",
      :revision => "29242081ea7d36c4f45ae4589004b9c6e1423a20"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4e1054f1fbbeef00f638d651068dba71bf9d5ec2f02233f4586e6c7ab0a76eea" => :sierra
    sha256 "5f62aa959b32d994cdd10f832219f25f7ff623d674e65c27a36661296e2384fd" => :el_capitan
  end

  depends_on :xcode => ["6.0", :run]
  depends_on :xcode => ["8.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

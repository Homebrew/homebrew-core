class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.30.1",
      revision: "c0f960f72fa1e6151695074ffa696e4da6c45ce8"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "62d580db4dc8cba7f301b35a2f67a87306a848bd89783de233f0651072316fcd" => :catalina
    sha256 "ba6360a1c7c67910f838bd40db22d5344150e9df576652b4727679705a436d8b" => :mojave
  end

  depends_on xcode: ["10.2", :build]
  depends_on xcode: "6.0"

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}", "TEMPORARY_FOLDER=#{buildpath}/SourceKitten.dst"
  end

  test do
    # Rewrite test after sandbox issues investigated.
    # https://github.com/Homebrew/homebrew/pull/50211
    system "#{bin}/sourcekitten", "version"
  end
end

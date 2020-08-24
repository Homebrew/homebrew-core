class Sourcekitten < Formula
  desc "Framework and command-line tool for interacting with SourceKit"
  homepage "https://github.com/jpsim/SourceKitten"
  url "https://github.com/jpsim/SourceKitten.git",
      tag:      "0.30.0",
      revision: "b7a7df0d25981998bb9f4770ff8faf7a28a6e649"
  license "MIT"
  head "https://github.com/jpsim/SourceKitten.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d08bed584c9f176c09f460aa77ec0dcbed338b557b3aa35d9913a778b28ceac5" => :catalina
    sha256 "2afc89c640799f55759d6b72b1e2ba694711ff434a7e883a052263b9e83d7692" => :mojave
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

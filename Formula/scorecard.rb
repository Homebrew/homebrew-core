class Scorecard < Formula
  desc "Security health metrics for Open Source"
  homepage "https://github.com/ossf/scorecard"
  url "https://github.com/ossf/scorecard/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "9d3f0dd0a82cdc4cb3cd69149ad0967291b1bafb751bb07bc9c92db00af613a9"
  license "Apache-2.0"
  head "https://github.com/ossf/scorecard.git"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    system "make", "install"
    system "make", "build-scorecard"
    bin.install "scorecard"
  end

  test do
    system "#{bin}/scorecard", "help"
  end
end

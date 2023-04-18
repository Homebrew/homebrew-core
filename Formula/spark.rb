class Spark < Formula
  desc "Sparklines for the shell"
  homepage "https://zachholman.com/spark/"
  url "https://github.com/holman/spark/archive/v1.0.1.tar.gz"
  sha256 "a81c1bc538ce8e011f62264fe6f33d28042ff431b510a6359040dc77403ebab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c98b248ad29955ccf560e99cb9c325fb28d881391c5bf9c0888251a02f41792d"
  end

  def install
    bin.install "spark"
  end

  test do
    system "#{bin}/spark"
  end
end

class Spark < Formula
  desc "Sparklines for the shell"
  homepage "https://zachholman.com/spark/"
  url "https://github.com/holman/spark/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "a81c1bc538ce8e011f62264fe6f33d28042ff431b510a6359040dc77403ebab6"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "538b171dbbf8740d4bd1ead547ed1928f3fc03d6846fd9ab1cc4a6c37707d09c"
  end

  def install
    bin.install "spark"
  end

  test do
    system bin/"spark"
  end
end

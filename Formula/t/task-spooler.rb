class TaskSpooler < Formula
  desc "Batch system to run tasks one after another"
  homepage "https://viric.name/soft/ts/"
  url "https://viric.name/soft/ts/ts-1.0.4.tar.gz"
  sha256 "b1ab3db52dca36af3699178b8d0e936a30107f8d5c86a974163c580823b01790"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?ts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6fab747d55e44eee46a7f17c3a0857634ba8b2cda0c49e34580358f2752a6a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ff018af3a0e83b17b8ceb146b94af90ef0056ba238d59f4e9967a7dfb607b9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8395b354eca22e389b532bfc213021857c03c339f7cca0a48856a67fd8cb2401"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5d5f7e3b8979d117fcf57b767a05fef940a9c7c11f6b7e7e6f64ee1b742543e"
    sha256 cellar: :any,                 arm64_linux:   "4777e0b42a6118c595bfcfe7dab7da9fcd3903c13d7882c95849c63a2e2e6263"
    sha256 cellar: :any,                 x86_64_linux:  "ea6f8903f5a2393c5479cad38be3286fea6776eae37d195f6bb60e0c9117e09e"
  end

  conflicts_with "moreutils", because: "both install a `ts` executable"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"ts", "-l"
  end
end

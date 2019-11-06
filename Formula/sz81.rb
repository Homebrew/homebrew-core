class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    sha256 "97f54508894d2dca7948b2798d0c76164a1ebea685a14f8be12e992883348455" => :catalina
    sha256 "b90dc9986a1f3f6fa93967745f331d55d4e8837e05e47b9b28d3ee9245e561d3" => :mojave
    sha256 "c23507f4f58b7144b2b4c0dd42ed6ae22a6d65661d15ea024ab8b65fd2a774ba" => :high_sierra
    sha256 "853475dfc7991beea12b01669e81fc35ce10e6a9b067716eb026e0ff693d5c4c" => :sierra
    sha256 "7a9b6ffa108486dea9514df6fbdd820a0e7b829c893ecb1b76a1b69ca8f39a21" => :el_capitan
    sha256 "a7f7cc5af1a1a42449da3169e18587df907369c94debf6bb15edba62acf0e199" => :yosemite
  end

  depends_on "sdl"

  def install
    args = %W[
      PREFIX=#{prefix}
      BINDIR=#{bin}
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    assert_match /sz81 #{version} -/, shell_output("#{bin}/sz81 -h", 1)
  end
end

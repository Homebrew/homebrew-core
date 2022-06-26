class Sz81 < Formula
  desc "ZX80/81 emulator"
  homepage "https://sz81.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/sz81/sz81/2.1.7/sz81-2.1.7-source.tar.gz"
  sha256 "4ad530435e37c2cf7261155ec43f1fc9922e00d481cc901b4273f970754144e1"
  license "GPL-2.0"
  head "https://svn.code.sf.net/p/sz81/code/sz81"

  bottle do
    sha256 arm64_monterey: "d6faa56681dfc773656d9e805094d65de3468398b3658b4c90ba9f55dc0e8db8"
    sha256 arm64_big_sur:  "d2a39ef1e7b6a82ac49f7da0a5ba0d9cb0eb8367d45c1665d818887254e75112"
    sha256 monterey:       "cbfc3b79a75698fc872415530a12c7bdb3eeef6de4962e584b05723ee072ccd2"
    sha256 big_sur:        "77f285b59f8f2d758ff01086455bdfc267c26d4ccfb960d68e680410915cf74a"
    sha256 catalina:       "97f54508894d2dca7948b2798d0c76164a1ebea685a14f8be12e992883348455"
    sha256 mojave:         "b90dc9986a1f3f6fa93967745f331d55d4e8837e05e47b9b28d3ee9245e561d3"
    sha256 high_sierra:    "c23507f4f58b7144b2b4c0dd42ed6ae22a6d65661d15ea024ab8b65fd2a774ba"
    sha256 sierra:         "853475dfc7991beea12b01669e81fc35ce10e6a9b067716eb026e0ff693d5c4c"
    sha256 el_capitan:     "7a9b6ffa108486dea9514df6fbdd820a0e7b829c893ecb1b76a1b69ca8f39a21"
    sha256 yosemite:       "a7f7cc5af1a1a42449da3169e18587df907369c94debf6bb15edba62acf0e199"
    sha256 x86_64_linux:   "a9d7763f36159bd7cbba2ca56357e61de0dc72fe906c2f6e2feb53d9f14a941c"
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
    # Disable test on Linux because it fails with this error:
    # sdl_init: Cannot initialise SDL: No available video device
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "sz81 #{version} -", shell_output("#{bin}/sz81 -h", 1)
  end
end

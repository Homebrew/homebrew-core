class Thrulay < Formula
  desc "Measure performance of a network"
  homepage "https://sourceforge.net/projects/thrulay/"
  url "https://downloads.sourceforge.net/project/thrulay/thrulay/0.9/thrulay-0.9.tar.gz"
  sha256 "373d5613dfe371f6b4f48fc853f6c27701b2981ba4100388c9881cb802d1780d"
  # Similar to BSD-3-Clause-LBNL (i.e. BSD-3-Clause with an additional default
  # contribution licensing clause) but different phrasing from the SPDX license
  license :cannot_represent

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "eb92cf4715801f5889b767248ee53ccc473da2803c836e00651846de45dd2c38"
    sha256 cellar: :any,                 arm64_sequoia:  "8980e64ea2ecc17ba2e111d4798a39c7789fc1b0009c2f0ae5664b0fcff8603f"
    sha256 cellar: :any,                 arm64_sonoma:   "d26583fd1ddd768813b4b89c02d46862821e356bf6c009cd1ecf985363ab4317"
    sha256 cellar: :any,                 arm64_ventura:  "bfbbc0ce92dbcfda1209154db22b59916f996348b77bf8421a4c70a6b5bcbba1"
    sha256 cellar: :any,                 arm64_monterey: "d9520dcaf88a54de7a0cbab36185a133a20b003332ae0e9b7bc6abde9fd10da2"
    sha256 cellar: :any,                 arm64_big_sur:  "70bb8243a69fe2432baba1ca86f440d607e3e87811d62d70e025c3b095999228"
    sha256 cellar: :any,                 sonoma:         "8c5239b3206e4eed48cb5cc35a87eb9e7305dc773245b0ec7e912b04e3d8f9d2"
    sha256 cellar: :any,                 ventura:        "77520bf722d669ecc5db10c8d245b1db3969935242d791df066f4cfa0be689bf"
    sha256 cellar: :any,                 monterey:       "130e94a8ba3c605f200d818f1d3cac45223d8f53837f39d1a5f03d48177bad35"
    sha256 cellar: :any,                 big_sur:        "ad146242acc5078690b249d86fa2336adbc93a47543138c9e9c383a1b4a18460"
    sha256 cellar: :any,                 catalina:       "fa6da453412e97cf222c12f7c2aaa7ef3e2db5d58dc98538c364b377ece63c62"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "cbfc443848749b0d2cee05c74f2c27a8d734cad7c274c86b0d97b3081ddf8a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cdfd861122990076cd447dea49124c4cf5a1629c3ca1a3540b98a12c19fb87"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    ENV.deparallelize
    system "make", "install"
  end

  test do
    # prints "thrulay/2 (client part) release 0.9rc1"
    system bin/"thrulay", "-V"
  end
end

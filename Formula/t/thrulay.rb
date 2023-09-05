class Thrulay < Formula
  desc "Measure performance of a network"
  homepage "https://sourceforge.net/projects/thrulay/"
  url "https://downloads.sourceforge.net/project/thrulay/thrulay/0.9/thrulay-0.9.tar.gz"
  sha256 "373d5613dfe371f6b4f48fc853f6c27701b2981ba4100388c9881cb802d1780d"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bfbbc0ce92dbcfda1209154db22b59916f996348b77bf8421a4c70a6b5bcbba1"
    sha256 cellar: :any,                 arm64_monterey: "d9520dcaf88a54de7a0cbab36185a133a20b003332ae0e9b7bc6abde9fd10da2"
    sha256 cellar: :any,                 arm64_big_sur:  "70bb8243a69fe2432baba1ca86f440d607e3e87811d62d70e025c3b095999228"
    sha256 cellar: :any,                 ventura:        "77520bf722d669ecc5db10c8d245b1db3969935242d791df066f4cfa0be689bf"
    sha256 cellar: :any,                 monterey:       "130e94a8ba3c605f200d818f1d3cac45223d8f53837f39d1a5f03d48177bad35"
    sha256 cellar: :any,                 big_sur:        "ad146242acc5078690b249d86fa2336adbc93a47543138c9e9c383a1b4a18460"
    sha256 cellar: :any,                 catalina:       "fa6da453412e97cf222c12f7c2aaa7ef3e2db5d58dc98538c364b377ece63c62"
    sha256 cellar: :any,                 mojave:         "8b15107dd47fcf14a6060c2dc1a740c4b6c5be66775486d396a90bd810e6c069"
    sha256 cellar: :any,                 high_sierra:    "e0d81a536ac3dce349b093394af8d7b89f531deb1854aa44a5b46068c1e02162"
    sha256 cellar: :any,                 sierra:         "00938642d65ba687a0ef83e85f682d6bdb1df02a7807fc3d337e3ca473af1cf9"
    sha256 cellar: :any,                 el_capitan:     "74f52b9eaa39092931b68630eef408db6b53e1b0c538ec52950b89d0a4ea5563"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66cdfd861122990076cd447dea49124c4cf5a1629c3ca1a3540b98a12c19fb87"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end
end

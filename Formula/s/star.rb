class Star < Formula
  desc "Standard tap archiver"
  homepage "https://codeberg.org/schilytools/schilytools"
  url "https://codeberg.org/schilytools/schilytools/archive/2024-03-21.tar.gz"
  sha256 "4d66bf35a5bc2927248fac82266b56514fde07c1acda66f25b9c42ccff560a02"
  license "CDDL-1.0"

  bottle do
    sha256 arm64_tahoe:    "68e80e10e9424184f4c94cdfff0adc5f3ef236fb89487142f228654ca44c5bd0"
    sha256 arm64_sequoia:  "e6a35a48d1b10d83a521fba9d7351be44be87017b0b7a1c16d6db72aa3874ee2"
    sha256 arm64_sonoma:   "4f7d3a2831a685b8ff9881ff5b56fc2402b04c410d6a8b3640d4cb794154165d"
    sha256 arm64_ventura:  "800616aa187156f940ce52ad810e23b6fe385a633948f3d666372cba6fea9727"
    sha256 arm64_monterey: "066533943950ef805516fdd1e22b845c02ad7764b924f2922689a27549260cbb"
    sha256 sonoma:         "e30e6506794c00b9eb288edf39bd4910e8e0a9742793319b96c48dea5f24d81d"
    sha256 ventura:        "697228bef43eb329599da53d6156a374c008fa508473ebcd79d0dccaec003b82"
    sha256 monterey:       "3898a6a463bdad06cbbce3792f8ef73909e98ef9f9db4483317e43a846d4175a"
    sha256 arm64_linux:    "e5bab1fe56ec1b2294719de3bf9e6576f439478e076a7df062693d9efc22ace8"
    sha256 x86_64_linux:   "a132ee6b490220cb5c060736aa796fb70b04227d53f115e605d30bf5d2784f9c"
  end

  depends_on "smake" => :build

  def install
    deps = %w[libdeflt librmt libfind libschily]
    deps.each { |dep| system "smake", "-C", dep }

    system "smake", "-C", "star", "INS_BASE=#{prefix}", "INS_RBASE=#{prefix}", "install"

    # Remove symlinks that override built-in utilities
    (bin/"gnutar").unlink
    (bin/"tar").unlink
    (man1/"gnutar.1").unlink
  end

  test do
    system bin/"star", "--version"

    (testpath/"test").write("Hello Homebrew!")
    system bin/"star", "-c", "-z", "-v", "file=test.tar.gz", "test"
    rm "test"
    system bin/"star", "-x", "-z", "file=test.tar.gz"
    assert_equal "Hello Homebrew!", (testpath/"test").read
  end
end

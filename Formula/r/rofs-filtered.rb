class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/refs/tags/rel-1.7.tar.gz"
  sha256 "d66066dfd0274a2fb7b71dd929445377dd23100b9fa43e3888dbe3fc7e8228e8"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_linux:  "01d57c6c071aacd6dc92a36f807b1e718f6178b8078f1d871d59941a7228670c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ae07e1e4a0daa79c067329aeafc4078dd7f74c793ccb1a2ade7c3dedf0f05ade"
  end

  depends_on "cmake" => :build
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rofs-filtered --version 2>&1")
  end
end

class Taskd < Formula
  desc "Client-server synchronization for todo lists"
  homepage "https://taskwarrior.org/docs/taskserver/setup.html"
  url "https://github.com/GothenburgBitFactory/taskserver/releases/download/v1.1.0/taskd-1.1.0.tar.gz"
  sha256 "7b8488e687971ae56729ff4e2e5209ff8806cf8cd57718bfd7e521be130621b4"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskserver.git", branch: "1.2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "61cffe43c79c6f9b87120529a75db6303a304526f47426999b22a3115418ee7a"
    sha256 cellar: :any,                 arm64_sonoma:   "e3bb75dc9d5d281fcdd7a9eb5604d5d17f36791458bf69c91a88403c385913f3"
    sha256 cellar: :any,                 arm64_ventura:  "dff5f74888539c8a37113ff4f0cdb5c4753a6bcfd8cba312978eada666286b6e"
    sha256 cellar: :any,                 arm64_monterey: "d965204a53afd9cb1f71824fffda964a63ca016560d31d8eabe7d1e2d87f804a"
    sha256 cellar: :any,                 sonoma:         "f95e28f8daaea0136706ae30efc5c12afcae319e8ee29de57318977f30d3d118"
    sha256 cellar: :any,                 ventura:        "1654093173dc0c9e2fba9bc9be2a50d28fe437f9332f853b54c4b3cf503b6eae"
    sha256 cellar: :any,                 monterey:       "a0131221a82276fc6feb0bec88b260d6731d346e05c84570b7f8ba376d1714eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1d85ff632c1f5b0eb1bddf79925f0ef64bbb38ecfe4d811d4560ee166c461cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d81536e57b798ded725ca302e02ff8b57e49445b02346508a5a707c925608a8e"
  end

  deprecate! date: "2024-07-04", because: :repo_archived
  disable! date: "2025-07-07", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"taskd", "init", "--data", testpath
  end
end

class Uchardet < Formula
  desc "Encoding detector library"
  homepage "https://www.freedesktop.org/wiki/Software/uchardet/"
  url "https://www.freedesktop.org/software/uchardet/releases/uchardet-0.0.8.tar.xz"
  sha256 "e97a60cfc00a1c147a674b097bb1422abd9fa78a2d9ce3f3fdcc2e78a34ac5f0"
  license any_of: ["MPL-1.1", "GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://gitlab.freedesktop.org/uchardet/uchardet.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "9c7726503e9063cc35716cd81cd22ebb8dbe34aec0922bd02d90b5a435940476"
    sha256 cellar: :any,                 arm64_sequoia:  "171e31b14ade23db98fd45f32cebdd1c278ce5b5d629d4e3be7c81a56bee03a7"
    sha256 cellar: :any,                 arm64_sonoma:   "70b2c779c315b71c067c8f4a743a90688dfa329c9d5e1c174345d0071fdf09d8"
    sha256 cellar: :any,                 arm64_ventura:  "a85a41114a32e8a455a0940c5d1f9b475a2dcb15b0041966cde44f632c5f8caf"
    sha256 cellar: :any,                 arm64_monterey: "b8da933deae20869dfec3d4d04688424230adc652863dc7015b73ed8ffbdc028"
    sha256 cellar: :any,                 arm64_big_sur:  "96c2ca2cfaef487e62d7286fe76df3f50fba67fe22b21bffb8478cbed2eb3e0a"
    sha256 cellar: :any,                 sonoma:         "724236eec957527714222c9a831ffd648cdf0a371dea3d80dd1cd91fbd245aab"
    sha256 cellar: :any,                 ventura:        "a553c6d711641482107e7604e8d81e00a615932f1a79cdb2cdfca9cd22a3d6db"
    sha256 cellar: :any,                 monterey:       "52b6ebd4f6db0057634f195332a98b18d0f1dff5e7911e550291cb91c86b54cb"
    sha256 cellar: :any,                 big_sur:        "8da0b45a3f4d87647b96aea829a3db161ef364eb131529b6393b718f5478006a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9fbe4342fd9a7bfd00ec092ca4cf8931d8dba18b79a7158496e60755790b18d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6392159b044059cbf22acfbe579343e119a8639dcea266e93a49b5e1a0bf08df"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", # Workaround for CMake 4+
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "ASCII", pipe_output(bin/"uchardet", "Homebrew").chomp
  end
end

class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-01-29.tar.gz"
  version "2025.01.29"
  sha256 "430a60b3dd5922bb8533b04b4e70fc2249de3c9dd1b1b5ea884d833a09e16b5c"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d056425727090abf192b46118eedb39d6c593026f96bc9f7dbcc8d594009c3fa"
    sha256 cellar: :any,                 arm64_sonoma:  "c46cc4b99e55eeb8bfba7cb90caf4cda949090c5344469661e322bfbb1a7c071"
    sha256 cellar: :any,                 arm64_ventura: "0bc3b1d6f22983510254725f5d9c1b5e9044aed3e439bad57002534099da2e8b"
    sha256 cellar: :any,                 sonoma:        "060d746c079d5b5e20c932df0794c477f46897e8d89c372d39ac6a59d3959811"
    sha256 cellar: :any,                 ventura:       "b3d1d83f8f60deba73747484378e059d6fdb2ea3fa0497e90e4e33e19d654968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "acc7c85827abc74da04d99773453d1b42c9bc90f192a72bdda1bf62332619d73"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end

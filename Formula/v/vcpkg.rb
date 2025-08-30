class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-08-29.tar.gz"
  version "2025.08.29"
  sha256 "017df4120fbd237d66381418631ec041ecec1f31dde50163878bd40ab41ee1b9"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6444cdec0438c09e493abef730b92ef068c2ffbc27657497078c2ff180de73fb"
    sha256 cellar: :any,                 arm64_sonoma:  "662b14c59596da606a5d08d26b02039633b42013850fbe16860c300780fa2be7"
    sha256 cellar: :any,                 arm64_ventura: "9ca03f0681ddd8c6beecf5784dbd48ca7d737dfdfacda1db53357a1a95b1ab89"
    sha256 cellar: :any,                 sonoma:        "b8018196923332ad7859d2f794df2a1168ff2e8ae18155db58c2776b73dbf1f5"
    sha256 cellar: :any,                 ventura:       "8354e8d085753af489d853f64e6c07819df56c1b9a2b3bec2c3b9b7e2dc4499c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "193951f81a7751ce931d3f62db19dbb04e2470add13227a5647a1a05ee3ae07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb1cf3cec261bbf40081ef6a857b7039ed589bb21f54a3fc1aa23025a7fdf07e"
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

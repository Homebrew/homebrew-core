class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  stable do
    url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-03-22.tar.gz"
    version "2025.03.22"
    sha256 "767b78481bc518e1886a5f8a7473059e21b7d5305d036a1e87241c2014413955"

    # cmake 4.0 patch, upstream pr ref, https://github.com/microsoft/vcpkg-tool/pull/1632
    patch do
      url "https://github.com/strega-nil/vcpkg-tool/commit/2bea367a563f990e53224bda37df7926518882cd.patch?full_index=1"
      sha256 "e528b7e3030c5b9abae25654eeeb7e096c2e40740e5cfedecf3b3b1c9992615b"
    end
  end

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
    sha256 cellar: :any,                 arm64_sequoia: "36ac645e4fa1018700f923c28d16b42ba0c9fe5dda2a49ac860eed5675bf2c3b"
    sha256 cellar: :any,                 arm64_sonoma:  "f29648cfafbd026c78a577c2c2f749962597efd061c8b012ffe5d5c3276c456b"
    sha256 cellar: :any,                 arm64_ventura: "1aaf7c84d3596311c0f15131d4098f7871f5f7c0e7f1b74a9b1717984b391ece"
    sha256 cellar: :any,                 sonoma:        "35675bd36324438fd24aedfe5b1ab617da129138e4b27e1cb965c1d0d496ca8c"
    sha256 cellar: :any,                 ventura:       "c0b9bacc3bc762aaeb8e936d7090fdd362991dedaa86b8771257177a196c2d16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c4335ff933d3d6c9c6358da9aa1edb1c8d2ec721c29246161ac4dc84ec6dc4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "242de51c81b1d0eae46654f63533b786c0658140fd835983ee57f31cadb967cd"
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
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", # FIXME: workaround for CMake 4+
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

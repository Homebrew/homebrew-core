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
    sha256 cellar: :any,                 arm64_sequoia: "e602922e40a89f0c9df7b9c022745206d31976ee251075db045ecd4040f8a04c"
    sha256 cellar: :any,                 arm64_sonoma:  "8ee2fd61d9e57347ebdd1203a7c76f1c7eac84b991c820d8c32b7bd267416e3f"
    sha256 cellar: :any,                 arm64_ventura: "1479c4d83b06137bb95d1b3897c0e97424eda69aeb2568c10b703b2c992cc56e"
    sha256 cellar: :any,                 sonoma:        "e8060fa9e2fc621020b458ee3ce6cca4649f5de74dc13ffaf6a76a4a5c236360"
    sha256 cellar: :any,                 ventura:       "1e47b5fef0855eac2496be1d12e9382f924228fefd587e14e4cd2189f68322a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08f20bb8922bb4abeb021a5de2319c9f0db96528d361a33f3cd85dbb134fb51e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4455b3c89973661776af7d8b2309f53aaa6e6ed735d0e3a4d3c7108389f5faae"
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

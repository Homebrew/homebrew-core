class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-03-14.tar.gz"
  version "2023.03.14"
  sha256 "b8ab11635140587b1bad6ca24ab78d1f4036203f098e2b733fd13df951462de5"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b7035fe4e96380325d7b9a85d8b33e131055e8aa546285bcf178a181e2712ae5"
    sha256 cellar: :any,                 arm64_monterey: "babf5b571237811c2bd618d90460c1d44c8c75d21fd8a7c60396abbf7f34cac6"
    sha256 cellar: :any,                 arm64_big_sur:  "c26a51ac04bf45faf11cc1bd12725be32968c6dffa729991fe4def5dedb0a3d2"
    sha256 cellar: :any,                 ventura:        "0271a94917f96b6604e82167204924075ecf6bcd7fb5e18081376ba90727280e"
    sha256 cellar: :any,                 monterey:       "a54d0632e18eb295804f4718febceb2014ca4a26d69df0269607d56f00ce8148"
    sha256 cellar: :any,                 big_sur:        "241a278a7c197ad5d9c764137d9e94a837592c166eb3dd5ed19a03921e32ed69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9281a8537dfc590738d63f8dee9d89e5f19faad47cda96c1fff89f14ecaf2d89"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["include/vcpkg/base/messages.h", "locales/messages.json"],
              "If you are trying to use a copy of vcpkg that you've built, y", "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
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
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    message = "error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end

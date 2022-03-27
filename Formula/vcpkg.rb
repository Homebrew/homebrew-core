class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-03-09.tar.gz"
  version "2022.03.09"
  sha256 "174a9081059efc29f8c617e6d673d342388816872a3c57c7042051d029b77841"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9876b58572d7337e07b2528070037258682d2f6ba3ca3c37df221cfd10605d29"
    sha256 cellar: :any,                 arm64_big_sur:  "39df2d10001621063de926d427f854a7a5bb419f813782c23fca71ab2a4ef09e"
    sha256 cellar: :any,                 monterey:       "62c62da16ae59fd1b003722aef6b4d0853d68bb5f696ba15f626b3c63d026c03"
    sha256 cellar: :any,                 big_sur:        "e937ec387b962ec67f15c3e0cb9456f22b6d7be4dfbd0a517598c5ab3a7abf6b"
    sha256 cellar: :any,                 catalina:       "14440a9255341d0a2d68e78ff54bff9deca91ed1dfa645dfb022ea964321b303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85287583bb21bda7eb08c6badc6594cbc97634000559ff8287fa00d75f1a7cb6"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["src/vcpkg/vcpkgpaths.cpp", "locales/messages.json"],
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
      This formula provieds only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    message = "Error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end

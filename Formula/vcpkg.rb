class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-05-05.tar.gz"
  version "2022.05.05"
  sha256 "c2d02a979b648d8e640c1704d72766e68ab783f03c6eb89f1ad5a6645fd7f547"
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
    sha256 cellar: :any,                 arm64_monterey: "bc7dd4a9c8724750e7d90fbeaf5037b563f88064a22f7772ddb6e66f37b22f50"
    sha256 cellar: :any,                 arm64_big_sur:  "efdfa29ed81867d6feb9612525f40ec07a2e57452731c62ad9b3b77cd7b7ee6b"
    sha256 cellar: :any,                 monterey:       "02da041fb48efd6faa1494f3a63ba20a7b393ae82ea3579cccdc4962090a0ad2"
    sha256 cellar: :any,                 big_sur:        "50fa6e45ea67402e04e39774d36227a2a02649e7b617844dcbf4017a874bc60f"
    sha256 cellar: :any,                 catalina:       "b56f27696e41f557bfc9ec210ae7e21d287e1086e37dc0f43a7cd2009c6dea40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c5e4fbc5a2fd2f47cdbbbf29922aadc3fe526bcbc508582737b1f821cc728b6"
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
      This formula provides only the `vcpkg` executable. To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    message = "Error: Could not detect vcpkg-root. You must define the VCPKG_ROOT environment variable"
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end

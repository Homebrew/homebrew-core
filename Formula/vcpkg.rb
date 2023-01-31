class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-01-24.tar.gz"
  version "2023.01.24"
  sha256 "28f8204db4491723bf3922930b5ac77d99c1ed90b323ebe5dcd837bda96b3120"
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
    sha256 cellar: :any,                 arm64_ventura:  "48f6fa14d520dbc8386fabfe4752c7843944f01478aadee337d4ed037e14f733"
    sha256 cellar: :any,                 arm64_monterey: "9374bb1058a18797820cc7d23a25334eb5bd73d136800fdca07079315818260c"
    sha256 cellar: :any,                 arm64_big_sur:  "075253cc7dcdda2b0660d2af1f50460b67459cae72eec0528f15a3e09141162f"
    sha256 cellar: :any,                 ventura:        "f5bfd1ae3636afb08a95343f2fca38aa22497af65bdc66f00774ce395ec178c2"
    sha256 cellar: :any,                 monterey:       "7a3c1772b5e862ec0d542b5472b9c06234b57318ab3e3c98ded6d788a1a521f4"
    sha256 cellar: :any,                 big_sur:        "a42b0897fe6b62ecd890c8f3c1949f08eb8a36e1377eabf8ba0c73b994cb2d50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c9eb7d82050cf6c7e6e0087dc7381b335983a0230d4dfa0538e73643bd8984e"
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

class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-10-17.tar.gz"
  version "2022.10.17"
  sha256 "04662d6185276ff8f0f8d4ebb7e369db0ff3249ce4a0720b335355d9f7407072"
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
    sha256 cellar: :any,                 arm64_monterey: "f875fc8a606bd29bed2eab1a5f513a00639873c499a2654f48293f2a1a689d59"
    sha256 cellar: :any,                 arm64_big_sur:  "1ab0373c921967abfd6326cfb4dcd4bbdc3f9c2f55d79c150f2cdf5efb0aa37d"
    sha256 cellar: :any,                 monterey:       "21f8c27ad8366ab5e57448d6920bac533237e797b49151f806b7e63736d914c3"
    sha256 cellar: :any,                 big_sur:        "17208b8e050a64ec7db494d40ae65bbc626314691df5da6fe3b8b2099a1e5b30"
    sha256 cellar: :any,                 catalina:       "bbe3183645786af27b53944eea5f00b08c8afe9a983fbdad3750c312bb370230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0234fdb93fa918c9489d2f8d456772a3325cf26a706aa34b1ab45d8310e8234c"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace ["include/vcpkg/base/messages.h", "locales/messages.json", "locales/messages.en.json"],
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

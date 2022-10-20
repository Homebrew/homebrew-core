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
    sha256 cellar: :any,                 arm64_monterey: "79afb9bb2e4338f439a6f280b839e499b9a88eb3ec984b2e9f1641f84178adc5"
    sha256 cellar: :any,                 arm64_big_sur:  "ce788d7abcd355b7bb33fa599858c3912ddb29a88b168ef12a4bfa17510cac0b"
    sha256 cellar: :any,                 monterey:       "ca338d600396f34fdd291fecedc5ebd216c79fe7105daa34158a089955c269e3"
    sha256 cellar: :any,                 big_sur:        "4319c0ba1add14bc2bec70e6241ff13b96b38859dd3c02b9edb308de1527824c"
    sha256 cellar: :any,                 catalina:       "d3a481cc70a8c4a3af3ff6cce0e0760d72405632111d612fbb8a029954b82364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea9e5174f26f24ddd8098664387fdcf869f844938ea79ffd3df2966062840d31"
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

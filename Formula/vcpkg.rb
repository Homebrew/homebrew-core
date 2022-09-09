class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-07-21.tar.gz"
  version "2022.07.21"
  sha256 "44085e694a913d529d8f16d03cb9d3c7ba614e82452fc0156bb075f7f6df5920"
  license "MIT"
  revision 1
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2de454e03fedee3166f2a4be0c1f59297f699e058427be3ced8e3bc41d305c2d"
    sha256 cellar: :any,                 arm64_big_sur:  "a7242d2bf802deb9ca3b793c7c83787fc1a04a8d7c321abf5b2451d546ab1c7c"
    sha256 cellar: :any,                 monterey:       "a82e7e4b09f453de0b3badfd28bf38c394935b36e9c7d373a1e2d600132d531f"
    sha256 cellar: :any,                 big_sur:        "6e5641ac22030db3792eaf997be464ae9f0dff508f5e22a9bb6f6ccb1d4c5320"
    sha256 cellar: :any,                 catalina:       "30f3eb90c5b5db20bc0f26f8ab45b80ae309f28d0b0921a34776a76ab80d144f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c6744de38a161beec485edfbd8d9ba7e2ee04b6eb5d5312e195806cdf1cb363"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  # Fix build with fmt 9+
  # https://github.com/microsoft/vcpkg-tool/pull/634
  patch do
    url "https://github.com/microsoft/vcpkg-tool/commit/5fba654cc47c175202491a5d80f280c0e39b364d.patch?full_index=1"
    sha256 "e9a61b8fc8e2ce21ae5eae36bf36b5e5214b0a624ef7c938ddea0e739a61340a"
  end

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

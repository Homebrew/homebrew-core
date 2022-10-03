class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-09-20.tar.gz"
  version "2022.09.20"
  sha256 "a501380ac03a926fdd62fb5c4fba1ab66e01b96ed3a0834d6904b580c927a01c"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "0ef4c2d5ad9e805e72ab14ec249507a552f05bd5c25f79fd1f2507573e4c6acd"
    sha256 cellar: :any,                 arm64_big_sur:  "8ea88c4b5374948089d77758a0367f7b2ad32c4c485dfe0c1e892bbc1ab1e812"
    sha256 cellar: :any,                 monterey:       "4e083328d0521418de251afb9cae430da44e8d43a0f76192014daf24123edfbe"
    sha256 cellar: :any,                 big_sur:        "0350014bd128b538c5223cf8dc3ae18994960a5e8c76d247f144a633af37404c"
    sha256 cellar: :any,                 catalina:       "cac45071ae9efeeb7fd535270cd660c5fd918cc319985ea344e774cac94fc502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b59faa7888c6596e3d082508d1d49b76b64f5cae1f6e23cb8619c281ea05587"
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

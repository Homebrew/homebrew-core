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
    sha256 cellar: :any,                 arm64_monterey: "e56d14451c5fff08954f5e80b28fbdd526b8a3b67613b67e950fcea904c3a670"
    sha256 cellar: :any,                 arm64_big_sur:  "63e30448648cd0fd0a4c3061eb7ae9daae1ef12b5e427ab6116311a061c2001c"
    sha256 cellar: :any,                 monterey:       "ec36c7272114fabb727c9022676c84f5bc3122fcf0b15f46bbcd123ec4c33aea"
    sha256 cellar: :any,                 big_sur:        "a9167340b8bfec76065321945e99403ae94667d0601341aea657cf723af10cef"
    sha256 cellar: :any,                 catalina:       "ad3ee6bbc1bfeaf59455fc8f9fd853b7b65a7d626875159207fc10e054593edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6274ab6a2f28983a1125f45eea28ed1cb5d04009988b2092602091734f1724d"
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

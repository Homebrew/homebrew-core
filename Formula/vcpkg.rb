class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-07-21.tar.gz"
  version "2022.07.21"
  sha256 "44085e694a913d529d8f16d03cb9d3c7ba614e82452fc0156bb075f7f6df5920"
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
    sha256 cellar: :any,                 arm64_monterey: "57ae5dd4721893618e6f50a4e957a96b1621ad3f0f8091a86c78712de429f8d2"
    sha256 cellar: :any,                 arm64_big_sur:  "ce7b2193be5bbef7b2e89ba2f95405efd42fd48a191f05313ab1e65565c1e82b"
    sha256 cellar: :any,                 monterey:       "103fc3bea86cdcb9d121f3cb0ff8e28b577ac3df43178f60546acf1777b75e29"
    sha256 cellar: :any,                 big_sur:        "999fc54e6b29bf4caa96f271656b8cd5737c7d2d8eee6f30b560fb2821b4fdf8"
    sha256 cellar: :any,                 catalina:       "3e90803d3a4ab8e18fbccfd35bf16cde34ca6936e219b455f303ec99ce42d716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e50b4e832e4bbc4de85c41a39c955813d488c8dce7d2808dc06a4ad17076662"
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

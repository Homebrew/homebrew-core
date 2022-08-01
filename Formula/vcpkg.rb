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
    sha256 cellar: :any,                 arm64_monterey: "56242a4defed37dfc776c87958007a1f24b1af0a66330cb60b5e8e996e19c5cf"
    sha256 cellar: :any,                 arm64_big_sur:  "b04cea1fba4882080b654cc92456ac5eef4d7767c5df72854d35b88e7dd7885e"
    sha256 cellar: :any,                 monterey:       "5223b19db19972c2e815d7a957888d89852f61c1c041715babb44ab7a3e60d79"
    sha256 cellar: :any,                 big_sur:        "db9182f67ab7e1fa5ce4ad347aa1e1ad99df293af93c1bbe329b2ce56e2a62dc"
    sha256 cellar: :any,                 catalina:       "12e861335833186e2cd2e3b2116f1e5bb8005c545723e41d6ca6e572342800db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f06134faca402e7b3ef79c937431c97527137dd45171db4e340c0b37fd3dc9e"
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

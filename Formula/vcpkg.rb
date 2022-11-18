class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-11-10.tar.gz"
  version "2022.11.10"
  sha256 "627ff5da84e7464a68e154f3903484f9f063cc5141d5e5a9fa250b519be93c6d"
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
    sha256 cellar: :any,                 arm64_ventura:  "b23604d494d7828ea34abbfee6ea03cc3b69147a68f0dd02c8577862cb2a1445"
    sha256 cellar: :any,                 arm64_monterey: "12d265109751aa9a079de8c6e623aaf1ca65cacdd7f1e08aafe487173fd2b848"
    sha256 cellar: :any,                 arm64_big_sur:  "fe5147872359f40fb7d69f4fbe0bee9955adfd685de36a2cd06aa3d408f4b306"
    sha256 cellar: :any,                 ventura:        "04aae43207e2e4f23bcde6555b854c72f5b04bf3cb1ceaa7ef61ee9325bc341c"
    sha256 cellar: :any,                 monterey:       "7168472b517238ee99edcb0af0393955450ddd3fefb7d3ee2b4ac754bb965d20"
    sha256 cellar: :any,                 big_sur:        "cd10757928f9bca8639dc5076097852bf17f4faa31b31fd07d605f80a67fefe4"
    sha256 cellar: :any,                 catalina:       "82c8f01574e8eda55e9d5f8b26f8af42163fe6daeaed563c48605ab57ace73a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "318a04d05f0c87cbeef986557f41ed21f6ce3830f35e9f61e1b1a313416c9556"
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

class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-05-19.tar.gz"
  version "2025.05.19"
  sha256 "1925704ef97ad66ac46dd035d1d0fe28f587eaa212115bbc590664ce53981c92"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest do |json, regex|
      match = json["tag_name"]&.match(regex)
      next if match.blank?

      match[1].tr("-", ".")
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1510e99a274edd3a4694170eea92c4cf684fc92837c59b2ee2428de3abb6f838"
    sha256 cellar: :any,                 arm64_sonoma:  "41ed6051ffceb2a95341eee38d26a4015cd5cb0b10a6e68797be2c242feb98ae"
    sha256 cellar: :any,                 arm64_ventura: "64204565ac3492b95aae0c2a42317e559db674f115178e47735f5f6b2684dd22"
    sha256 cellar: :any,                 sonoma:        "d10eb9b9a16616cff65dba2cfa59fb8329446a0647fca48720fcaa8285250d9c"
    sha256 cellar: :any,                 ventura:       "2ba931d9099e9fe90784ab1b95d714efcd71502306ddd0668722add600fc8765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2bd989cebee3ed089f83ced7ba484e5696efd9c2bea68811948ed68a62e29755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca156b54a240e0353bc9e131ec213d1b6851f8b0f81c6f509edd71727f5c2aaf"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    system "cmake", "-S", ".", "-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.tr(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    "-DVCPKG_DEPENDENCY_CMAKERC=ON",
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
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end

class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2024-09-30.tar.gz"
  version "2024.09.30"
  sha256 "576f997b410cf8a998cf8a052ef29b0cd1e331ddcaf2082c15fd7d034af85321"
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
    sha256 cellar: :any,                 arm64_sequoia: "b5f3a93d3ad8ca6a596e180576bac16ee44c08dbfba54230995ac71cca01a3e2"
    sha256 cellar: :any,                 arm64_sonoma:  "483398f5596ec83fbbbb55df4e6e51b27541a091bfd669193258948741dd4a80"
    sha256 cellar: :any,                 arm64_ventura: "55600383741880231d937cc57db29c3cadca9397816aa4b4ce55ca2c7bfca3ee"
    sha256 cellar: :any,                 sonoma:        "6428709ef1429c25bef7ba25871758b5ffb61f24556eb23255b2d5432fad2bf4"
    sha256 cellar: :any,                 ventura:       "6b80b2ad1e45cc1ce2d9ba341a6317b033d10dfabd59f23f8bef880e317741e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f410d47b3b2a4030189558d633d711a9c46f3debc46b1b1aaf8e8e25473c236"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

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

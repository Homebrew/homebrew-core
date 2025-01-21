class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-01-11.tar.gz"
  version "2025.01.11"
  sha256 "7a65c4a982557f825dd29037ecc0483def8563e23feeff8cefa5ef34884c1518"
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
    sha256 cellar: :any,                 arm64_sequoia: "ed18032c657d956731503e6410423e441d83e7cc0189ca399345163500fdfaa8"
    sha256 cellar: :any,                 arm64_sonoma:  "d8aa874edd4c9f9b59ed0d62d7a3c7d8f579a44d640e210119040ce44afa435d"
    sha256 cellar: :any,                 arm64_ventura: "b4df3c087730f7b67448034e95642b678edcd4669d114c5c813ec11056bdb062"
    sha256 cellar: :any,                 sonoma:        "d4df628b70a528ed82422df32e1040252af362420507048b545f3f52d9d7b487"
    sha256 cellar: :any,                 ventura:       "d00e5943f234377df585a2bda007fd021747440156d7525b6f0c499f08a58ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7904920d1562cff855c6de82a76d2f79b489f847e4871f7aee9a0ff7cdcd72e"
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

class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-04-16.tar.gz"
  version "2025.04.16"
  sha256 "d0a1fdee0af8172991c12a02e6f3ed1ee4c33760a7680eea93685165335dc8b8"
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
    sha256 cellar: :any,                 arm64_sequoia: "fb1a0a958b91a10932c48c579d9053c8efd3d4792b08ac7717c67e7a7ed7ff2b"
    sha256 cellar: :any,                 arm64_sonoma:  "6973e3538b663122e2c62dec6c71cff7f05110b86b172db55b076b238fe8948a"
    sha256 cellar: :any,                 arm64_ventura: "8b56e2acff1ae7065436db37f1a3720d453fbe290752bd93a433c4ed83101ae0"
    sha256 cellar: :any,                 sonoma:        "88227dc54670fc05b95597d293fe5c1237d7c386ff352566b101a361014e6741"
    sha256 cellar: :any,                 ventura:       "3c8a5ff50903bac8c17ee145b883a3897cf22217e1ade4e5761766fb7b250f9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b25b847e9c31cc70d3f8b907db5f3593707d83e1536b4c2fa709e45ee6ccb8fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a573ef669c548b7410cddf1cc27ce0811a198e8d937b0a80758e02cd1b3ae89e"
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
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", # FIXME: workaround for CMake 4+
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

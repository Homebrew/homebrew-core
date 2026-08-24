class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2026-07-27.tar.gz"
  sha256 "cb2ac34ab85008876004b0817c0a82c96f773ce3aaedb9c35e8ebb523ef1754b"
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

      match[1]
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b429fb1abe840da46a9366149b7d3336f65e7b2a4a37e5d4695095e8b92a560b"
    sha256 cellar: :any, arm64_sequoia: "a7bf29257f3981012765a8b86c8afdf6b897467bb03d86493f90520e989b9246"
    sha256 cellar: :any, arm64_sonoma:  "8a97cd11abddff70f8b5363ae87472e1c1e15d7bd74610fbff062b52e8252f7e"
    sha256 cellar: :any, sonoma:        "17b680f59b3c21b3377b2c7b6059897f3cc5b7ca17beb0f69439b8114856cb35"
    sha256 cellar: :any, arm64_linux:   "256b2d557844524da68a8b2e088f76bed5e4e8038564f299d7cfb58811146008"
    sha256 cellar: :any, x86_64_linux:  "e75bcb94c99cd72a1e1db5046d41dd4df027e0eac12d0e775eb8478ff2feb514"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  uses_from_macos "curl"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "include/vcpkg/base/message-data.inc.h",
              "If you are trying to use a copy of vcpkg that you've built, y",
              "Y"

    # GCC 12 may vectorize SHA code into unsupported `eor3` instructions on
    # Linux arm64 builders.
    ENV.append "CXXFLAGS", "-fno-tree-vectorize" if OS.linux? && Hardware::CPU.arm?

    # VCPKG_VERSION is used by upstream for setting the commit hash
    args = %W[
      -DVCPKG_DEVELOPMENT_WARNINGS=OFF
      -DVCPKG_BASE_VERSION=#{version}
      -DVCPKG_VERSION=#{tap.user}
      -DVCPKG_LIBCURL_DLSYM=OFF
      -DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON
      -DVCPKG_DEPENDENCY_CMAKERC=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
    assert_match version.to_s, shell_output("#{bin}/vcpkg --version")
    output = shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
    # DO NOT CHANGE. If the test breaks then the `inreplace` needs fixing.
    # No, really, stop trying to change this.
    assert_match "You must define", output
    refute_match "copy of vcpkg that you've built", output
  end
end

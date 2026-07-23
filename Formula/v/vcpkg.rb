class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2026-07-13.tar.gz"
  sha256 "f17b6d1100469a594ea6414f4a16bb22c485e99125ca5db8235dee28a95635e5"
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
    sha256 cellar: :any, arm64_tahoe:   "6e0a3bd57f8e9b70de789510d71f20762cc8c0b08ec1c6b9d343e72c3fa4acf4"
    sha256 cellar: :any, arm64_sequoia: "2eaa81b3fb1565105fcbfd058229bced11c05595edfae4dcfbec9c17fb39f828"
    sha256 cellar: :any, arm64_sonoma:  "660fe62b2f8b95cdb4fae4cb628f7aba6f7d0225b56a1175c5f0e67ef01d6b33"
    sha256 cellar: :any, sonoma:        "cb6c93fa56f37b94aee84bb28cdcecfa8dd050b3bc579eda7eb7c51dc12d279a"
    sha256 cellar: :any, arm64_linux:   "d5477e1762386c8494f1139fe83bcd6afcdbe6bffc826ca21eb4e70bb3716e6d"
    sha256 cellar: :any, x86_64_linux:  "8996889ba566c6de86a4696e67acebcfa323d32308aca28591707b1263ca68e4"
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

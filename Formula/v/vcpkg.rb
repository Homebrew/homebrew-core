class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-11-19.tar.gz"
  version "2025.11.19"
  sha256 "d3da3f4f5666bafbabe56b1086a2602b4a59df37527cd813bd1eca3183dfaac1"
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

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "648e6834b99399768e45a04fd8e102e9465819b0915ab84acacccc41af8cf73b"
    sha256 cellar: :any,                 arm64_sequoia: "e36927e3c977cc137c4204b496b9086513f4812a01dce1cbcc49ef887ad2316b"
    sha256 cellar: :any,                 arm64_sonoma:  "71a1794318082c24ab12f37c232ee1bacf5ab63e2233e26cc305e5714b47e4fc"
    sha256 cellar: :any,                 sonoma:        "9311bca0cacb63b61cca20e9816b0b483ba809d94707a09a79053b92d9fae51e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a3281d6f7a04ea1013636d3ff505ba5f2ee364d76a090352b429af805c004506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20ad882483268d589d34e72ce5b1e211e8108fde0a2b011facb452adef45ced9"
  end

  depends_on "cmake" => :build
  depends_on "cmrc" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  # upstream pr ref, https://github.com/microsoft/vcpkg-tool/pull/1826
  patch do
    url "https://github.com/microsoft/vcpkg-tool/commit/7e5f9b42018d19172e87236783bb0c713f176b7a.patch?full_index=1"
    sha256 "2537ff975b66809c14790887090daacadcdd213123d6356a891667048c3b32fe"
  end

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

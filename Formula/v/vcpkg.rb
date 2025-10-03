class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-09-03.tar.gz"
  version "2025.09.03"
  sha256 "f0c4b30afc2f7baa9cc4372ac325042418251343e0192dbfac94c4f602e9d3ed"
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
    sha256 cellar: :any,                 arm64_tahoe:   "768f142d43f0b76b1184ff0cc9be026c7370a1a8d87ddc043acb1e1e8b3a45aa"
    sha256 cellar: :any,                 arm64_sequoia: "45137a872274a8391880cba9c71f4cad67c8090c697a08cafc9c94ef0ecb0e7b"
    sha256 cellar: :any,                 arm64_sonoma:  "51eb1d28c9e3770e9f17721cb325d095ac47155d43aa23ba7f056e693f2cc2c7"
    sha256 cellar: :any,                 arm64_ventura: "6fe91ab87ee5cdf5ec35aefcdb0ab4e1b9cd13fc52513d78208cfeb3c6f3bf3b"
    sha256 cellar: :any,                 sonoma:        "5b81e6c25f704c834cea28fe594a73ef526c0273c9b643434749f6071b19b9e1"
    sha256 cellar: :any,                 ventura:       "7ac8bbc813795f043eab5c92e277c301f48ee445898f8479e2f038fbee347623"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95989c7fa80dbccc27e2e41f17856627169b7adf47014c63191cd3a77a1698aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ddd36c07e0c97dd28479ecf6edb6674a62c64fe9ac2e45974816c69eec6dd16"
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

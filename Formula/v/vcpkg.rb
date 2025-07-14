class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2025-06-20.tar.gz"
  version "2025.06.20"
  sha256 "a5c13011d253db8e885c54d2da6f6460741fec307fe93ee38bf17ab34922a467"
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
    sha256 cellar: :any,                 arm64_sequoia: "c137688de0ad7bdc389c2bd9050a4db460e07c2fc349daf3dab2f263cd0177a0"
    sha256 cellar: :any,                 arm64_sonoma:  "6ba896fd6dd5f883377626ad30a7aa70dd72c97bb9fd97ee0cec7ac8d0db670c"
    sha256 cellar: :any,                 arm64_ventura: "b2ff9fcb7cfe5eeab3d642c15445846a28ea4e2183aae3fb76e77643b100d534"
    sha256 cellar: :any,                 sonoma:        "15e0038fc0f36d2e86732e9de52737d759ce5a666996cce26f9381dd080580a4"
    sha256 cellar: :any,                 ventura:       "3f03db528a5863adce0b860940a8b5f6aff274dc0b72cb95defb23753b45cf8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79bcf72c64a96f50e75e2ef39c9998ac23fa543db09221ca6f62b3c761ef216a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a12c6435af1fad099a80a48688a833228d2eb7fbc5522659a0050387d95ed75"
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

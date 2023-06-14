class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-06-08.tar.gz"
  version "2023.06.08"
  sha256 "b13cd88b019a64a7c169dcca753e44e677b351d461df5b133fc92b1aa982f63a"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(/v?(\d{4}(?:[._-]\d{2}){2})/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f0d3a7ec8f6c96f54cfa629186768a8457ef1bd679d20ccf479915b483c942f2"
    sha256 cellar: :any,                 arm64_monterey: "5a7abcf3536044f9abc560b3b0f5722a751db3399ad2622bdbe62c68cde04af9"
    sha256 cellar: :any,                 arm64_big_sur:  "81668741cd7f36072706ac1cad1d1f1ddca6f774e006b01723fe9732a23e7483"
    sha256 cellar: :any,                 ventura:        "acfdbee7f5e3fa4425cebb98646f3741ee870d63dc5a0141d2445bb35a0a9e54"
    sha256 cellar: :any,                 monterey:       "ac940ad91eacd2a4f5f0e5a1b9cf1ed8e401fdcebd03d78421f8e16f9fce6363"
    sha256 cellar: :any,                 big_sur:        "c407cee8a2038cd1cac5aebe420027c487c88fffa4ba39ebd71f7798c8aa567c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3386c3f7d1c040fed0a81c4768160ccb351732702fc0884e85b6135ccbe1f198"
  end

  depends_on "cmake" => :build
  depends_on "fmt"
  depends_on "ninja" # This will install its own copy at runtime if one isn't found.

  fails_with gcc: "5"

  def install
    # Improve error message when user fails to set `VCPKG_ROOT`.
    inreplace "locales/messages.json" do |s|
      s.gsub! "If you are trying to use a copy of vcpkg that you've built, y", "Y"
      s.gsub! " to point to a cloned copy of https://github.com/Microsoft/vcpkg", ""
    end

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
    message = "error: Could not detect vcpkg-root."
    assert_match message, shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end

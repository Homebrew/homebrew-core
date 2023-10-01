class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-09-15.tar.gz"
  version "2023.09.15"
  sha256 "d77fce62554ccc0e6f54983c22c559118a1cd96defc0e8f45202d1ab1cda9e57"
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
    sha256 cellar: :any,                 arm64_sonoma:   "4a7c35271390090dd420aaada69a303b35dc8a6480799926aa4ea40f21eecc86"
    sha256 cellar: :any,                 arm64_ventura:  "a217492a7309480e7e48ac9c22d4f7789c6f8eb08cf12a07c726c3e144dd2e4a"
    sha256 cellar: :any,                 arm64_monterey: "8800836ab11d5a687ba754c4c3829a813ce0a28c00426ac188ed44968f667f60"
    sha256 cellar: :any,                 arm64_big_sur:  "28cda8f35c7417a7e6ee3b904ce97855c4319f8d0fbe1a72eabff9bde81227db"
    sha256 cellar: :any,                 sonoma:         "55e87118173842d07978468911310d226c15ac1884fbe9c8fc019a3fb12bcce2"
    sha256 cellar: :any,                 ventura:        "56aecc9c5a2643e0e60b583637a4d78130be32c92f368e173abf6bac13da69c2"
    sha256 cellar: :any,                 monterey:       "8ef25f548ec3e837b056352ca6cdbe95d3e3e3967794fb68e6792dd328b6c4a0"
    sha256 cellar: :any,                 big_sur:        "0a8b8843634800437d594d5a009fa9660321c5138470130c3c99c8ac874e4f96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b0bc19bcce39fadb9bd9b30dea1ee185360b759f3304a1423e25e839508d74"
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

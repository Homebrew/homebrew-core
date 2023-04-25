class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-04-07.tar.gz"
  version "2023.04.07"
  sha256 "3ded5bf84ce56fc8e9e179a333eaa343cc1f4ac9246d20251a47efcfbc1fd101"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  # The source repository has pre-release tags with the same
  # format as the stable tags.
  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d{4}(?:[._-]\d{2}){2})["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb81196de81cd6ad18fd2ae2a7e9809cb62a35681db4848f4166f26087d7980f"
    sha256 cellar: :any,                 arm64_monterey: "4fc23ebf9eb83efc943499e7be36fa04b6bb523b30565101d86b5279d057579e"
    sha256 cellar: :any,                 arm64_big_sur:  "fa6f551e3fa546ce652f476e00f352771533adc946c8e335c43c41d7b6fa9b91"
    sha256 cellar: :any,                 ventura:        "e0c4fdf4908b6014a990a0d6bf5eda8ef12c0f703fba80ef00a37908b7d1a183"
    sha256 cellar: :any,                 monterey:       "bd60215e992d89e5733264c7edef3ca25ef01fb2e9cdce0ca8b84e9a170ee8ae"
    sha256 cellar: :any,                 big_sur:        "7a71437f7bcb87674f1804c575a3b8af069fceea261f989a2688dd22cb7fe0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a4a96ef79abf9122aae5179de9560721c917da63204f4360a8f145af2d85df8"
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

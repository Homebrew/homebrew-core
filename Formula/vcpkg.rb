class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2022-02-01.tar.gz"
  version "2022.02.01"
  sha256 "c32c8e98ba705d054dced56003dd7a9b7e367d0908b0b57730be54dc4024abf4"
  license "MIT"
  head "https://github.com/microsoft/vcpkg-tool.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8116bce6059d312ab0532fc41b37d7a1e96b3676aab2e36b1d700cdb4b777807"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e58d2e3fbf843883563579ec544828788ca051c9b5bd46edc0e5df71c35b90dc"
    sha256 cellar: :any_skip_relocation, monterey:       "65fcbc684c9d1a081ce9e21efe81c81a6688eef365057abb14006cc264f6de01"
    sha256 cellar: :any_skip_relocation, big_sur:        "d963bef9ed861e8e67c4ef2080f04adf3a91bb971776f60f3f40bd5a6a875e07"
    sha256 cellar: :any_skip_relocation, catalina:       "143a0c4e50b0d96bdaa7ed913105654188664ac105500c74f66add89fe1cf098"
    sha256 cellar: :any,                 mojave:         "301a0c5460bebfa3f05fb2ed8d264fce2a9fe9f261853fed991a59d1c1cd58ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aac3ac181306d79ac32984bdfecf34c9fa90703ed11e78044fae8630ca085222"
  end

  depends_on "cmake" => :build
  depends_on "fmt"

  on_linux do
    depends_on "gcc" # for C++17
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".","-B", "build",
                    "-DVCPKG_DEVELOPMENT_WARNINGS=OFF",
                    "-DVCPKG_BASE_VERSION=#{version.to_s.gsub(".", "-")}",
                    "-DVCPKG_VERSION=#{version}",
                    "-DVCPKG_DEPENDENCY_EXTERNAL_FMT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # This is specific to the way we install only the `vcpkg` tool.
  def caveats
    <<~EOS
      To use vcpkg:
        git clone https://github.com/microsoft/vcpkg "$HOME/vcpkg"
        export VCPKG_ROOT="$HOME/vcpkg"
    EOS
  end

  test do
    assert_match "Error", shell_output("#{bin}/vcpkg search sqlite", 1)
  end
end

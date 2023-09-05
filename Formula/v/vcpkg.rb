class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-08-09.tar.gz"
  version "2023.08.09"
  sha256 "ded27cd0959e9c2ac4ad252bf133b476e5fd9cd40f28fff9cd948f4817ae22bf"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da801ea8675772a643e1728ea3f12b18e6d180d8dfb5e4aed67e818a473d9950"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65d4db9790011a45f093bac904160056c749d2669143181a0fff1fd243d6e91e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7634470f665726a158a34f3d85ccc3896db9d61cda60fb0660bba88bcc8b9f36"
    sha256 cellar: :any_skip_relocation, ventura:        "dd38d37150e4933ba85f24f5b69331ec2276a7dad7b6ee4b7d342bdedbd5ca68"
    sha256 cellar: :any_skip_relocation, monterey:       "00a21565c3570f4185fef8c3909c1794e7f0fd47980a4b854125e71d82806e41"
    sha256 cellar: :any_skip_relocation, big_sur:        "509f370ed4c297a3909ca62d90d8e8d3aa87db22788fa265b5625d7e199e6f74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc12d0c4a18e485bdf51c8d4aa80c87bc1a15005e314d8df9620cb872d658999"
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

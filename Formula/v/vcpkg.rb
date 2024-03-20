class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/refs/tags/2024-03-14.tar.gz"
  version "2024.03.14"
  sha256 "2b89635be4832ced505915bf46bbdd09d8a13ffd4c9ae11754929c7d07f1b903"
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

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "760b9ad2dff149940b3ffcd255fa35503d1a89b57703ffa22a8691787acc9689"
    sha256 cellar: :any,                 arm64_ventura:  "85ebc1c97bf91204691e415ff7774448508ff87b5983cb6b0c664f0178fd3a28"
    sha256 cellar: :any,                 arm64_monterey: "f14a214d4fd35a5aa55af5da213c6cce7a57ec8eb6878fad92eab0e9d9d1557a"
    sha256 cellar: :any,                 sonoma:         "6c67066717d7fb9a98b58bfb3ac75cb003ffe5951f84c1509c24882cf2d0a34d"
    sha256 cellar: :any,                 ventura:        "ff7f5115e722ffbc801b36724c1e3c9f8efb823dfa8992d7c324726b01ebc606"
    sha256 cellar: :any,                 monterey:       "0122537f4b2b105ed89dd9504c754e12fff3c60df0461423b23f092a826821fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c76b1f6533887ba34cd597478e7e6875da382920287b75eeee7cc62af40d4d"
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
    assert_match message, shell_output("#{bin}/vcpkg search sqlite 2>&1", 1)
  end
end

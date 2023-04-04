class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-03-29.tar.gz"
  version "2023.03.29"
  sha256 "7c65aac0e1d6ffa12cc2bfe2c403364c05855518d12e72e704767de400cc322b"
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
    sha256 cellar: :any,                 arm64_ventura:  "7643eca39ace1da38f473fcba361d6499a2d39f0045cd678053172abaee63d3d"
    sha256 cellar: :any,                 arm64_monterey: "274f6c9a51b82ec32d5bd330d0f0a2b7d6e88776e7c4f54155f6d6ca2332805b"
    sha256 cellar: :any,                 arm64_big_sur:  "d3805721f0f5213ce8da7353ee517b9b63e69d6f76963c471af31ca652802325"
    sha256 cellar: :any,                 ventura:        "e681aaa128ad9735962a03538e767ad847bca918bcea6c8f06065e89e71fdfd9"
    sha256 cellar: :any,                 monterey:       "ca84737eb493f8afb015a46332bf66e434d6283583fc76916b00f0e40b4c9096"
    sha256 cellar: :any,                 big_sur:        "6d649a0819cd61e23a69de59f8c5fdda21d3df4652c925e65efc853a50f52bc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1b3aa2e85268b88edb6a66a656f9751f6765cfe6c81c17461e7e75e9df421f"
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

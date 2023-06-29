class Vcpkg < Formula
  desc "C++ Library Manager"
  homepage "https://github.com/microsoft/vcpkg"
  url "https://github.com/microsoft/vcpkg-tool/archive/2023-06-22.tar.gz"
  version "2023.06.22"
  sha256 "f05f76c80825171d776e592fa660b1667f3e09cd43dcb05cb3e8ebf7aedafb23"
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
    sha256 cellar: :any,                 arm64_ventura:  "cfd3a04ceee72d8ed98c2ba72c188e60d6ec6980897e4d0a574661fcb631cf0a"
    sha256 cellar: :any,                 arm64_monterey: "43c3814d93286a9e576afcedf1c99c647438ad1908bc60ada05307134eb92153"
    sha256 cellar: :any,                 arm64_big_sur:  "b73b86a37ab2843c1bc7a1ad91427ce084cd0d15376e0fd801ff4cd1d20a8fe6"
    sha256 cellar: :any,                 ventura:        "3eef0930b2b1585a8320abac5868e69aa28cb0413fe6296fb01d0221758890dd"
    sha256 cellar: :any,                 monterey:       "cb37c25b3e0a0531c2e836d1e4b69c18a29d387274c354aa45afe2f691ad43b7"
    sha256 cellar: :any,                 big_sur:        "726fe960fc425a79d0098be01f5c5259a1f086f2ce2d64eac3386828daee2815"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322e52578b44364618b63f32205a9a5e799eefbdf5b7f1086ef729505fece2cf"
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

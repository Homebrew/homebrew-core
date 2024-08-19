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
    sha256 cellar: :any,                 arm64_sonoma:   "46f238b2d0c392052b6dd716a3e77b457b682ba1aa86a4cca642371c54fccd0e"
    sha256 cellar: :any,                 arm64_ventura:  "4f40707d4a1ffe679812fc843f3e7de90900db537faee4522784e265391d2a25"
    sha256 cellar: :any,                 arm64_monterey: "33f91e669876591ae9c9943310b8a5ecba6a960a1df52e991af8adba630863f0"
    sha256 cellar: :any,                 sonoma:         "c1c4fe6676becfe1341ada5fa5f41382f005e1435b24ff70fc6ce2a52ee292a2"
    sha256 cellar: :any,                 ventura:        "c4ed24a61213bb33934ccc0a5fb3814605898e08e45a394606e05905d942d6b1"
    sha256 cellar: :any,                 monterey:       "a2e1475d6dd52ffa4ca63022d79931f0412473c0a995d723733c42b596bef090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef6d8032dc2b06b1256a6d0333ee5092a3e4c42f2d48ece414746f0fa9739eeb"
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

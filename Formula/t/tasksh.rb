class Tasksh < Formula
  desc "Shell wrapper for Taskwarrior commands"
  homepage "https://github.com/GothenburgBitFactory/taskshell"
  url "https://github.com/GothenburgBitFactory/taskshell/releases/download/v1.2.0/tasksh-1.2.0.tar.gz"
  sha256 "6e42f949bfd7fbdde4870af0e7b923114cc96c4344f82d9d924e984629e21ffd"
  license "MIT"
  revision 1
  head "https://github.com/GothenburgBitFactory/taskshell.git", branch: "master"

  livecheck do
    url "https://gothenburgbitfactory.org"
    regex(/href=.*?tasksh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "0b87af510cb7ba2daf5c1bc8b21d17c30a9ba43512dcc180beed93d9a8cda5bd"
    sha256 cellar: :any,                 arm64_sequoia:  "71cf7963bf3f6eab310007ab05aafb9be4e4c766f6446f79671073cc7100a83f"
    sha256 cellar: :any,                 arm64_sonoma:   "e03ada11df6af02686b40955cd55f00851e00ec558cbedd71bf84c1ed5098b94"
    sha256 cellar: :any,                 arm64_ventura:  "1a8bbc54e5712ab5b9caa686e6348365da4c8bdaebeaae474be2edda28368d72"
    sha256 cellar: :any,                 arm64_monterey: "6c6390a79e5f4645f2cf2507a1c29ad1b935a5f51d87387412e557343688a11d"
    sha256 cellar: :any,                 arm64_big_sur:  "590c43b791080cc6ca56cef896c9e75a8ca77915b061a1d0a711a0489e69ab63"
    sha256 cellar: :any,                 sonoma:         "fc26e6d677232268991d4926c4c2e5f13f839918be416b4675326d227f4fc1ac"
    sha256 cellar: :any,                 ventura:        "d0a97986a19732ce4d3818c5b452f6ce636ce957e401350cade47190e5b7b2e0"
    sha256 cellar: :any,                 monterey:       "778d32859e2a65b224819a39d022611b7959fba4d72d08a45d42f76bf6cf6cf8"
    sha256 cellar: :any,                 big_sur:        "987789014e770fb3b4b1d4500321877c457ba2a1dde2fc9925762dfb0d7da541"
    sha256 cellar: :any,                 catalina:       "68a13aa8ea81fd1fe7c2c5e9eadd3850fe21265b34c4cf2f1cf7e7ede3caeaee"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c18914e24a50c9ea3489db09b04c7d702555bc703bb799ff51244419135f5bca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8a89402e614a9f93aa6716e6b4c442b44f2f0471c0d8534096ee8428565a149"
  end

  depends_on "cmake" => :build
  depends_on "readline" # Possible opportunistic linkage. TODO: Check if this can be removed.
  depends_on "task"

  on_linux do
    depends_on "readline"
  end

  def install
    # Workaround for CMake 4 compatibility
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"tasksh", "--version"
    (testpath/".taskrc").write "data.location=#{testpath}/.task\n"
    assert_match "Created task 1.", pipe_output(bin/"tasksh", "add Test Task", 0)
  end
end

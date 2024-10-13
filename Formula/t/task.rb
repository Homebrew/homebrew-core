class Task < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v3.1.0/task-3.1.0.tar.gz"
  sha256 "1ae67c74b84067573a53095cf3cb6718245dd7dd808f19f9b3d85da445838b4f"
  license "MIT"
  head "https://github.com/GothenburgBitFactory/taskwarrior.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "02f376c6638867055daefc4e58c8a6c9c47e58f33486b7f5fbf102fc46bb5d2f"
    sha256                               arm64_sonoma:   "cd7123d91d1f32ff460957a4a3d09e7b0816c407a9d604361899ce5e7bf7ad20"
    sha256                               arm64_ventura:  "0213581f5102105e16537570650842cdc1ac8a8b2bd046b588083c12842f30ee"
    sha256                               arm64_monterey: "b1f264092d279911e203a31a8378dadd2d48d1c6d4e3313f554b7c33e075a4d8"
    sha256                               sonoma:         "d9a1e86dbef78947254cbee9d93be1ca2ab5afb118184093ddb247c6560745bf"
    sha256                               ventura:        "a412941738429a46105e3265ec6c17887722fc57adb569778a76f83ce4313abc"
    sha256                               monterey:       "60cc3d6e6ed923b0a049ba6867677a8a9c5f226e804a22ae90b622a2590556d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15dc50d9db72f572fb3d02f190d36dabf485d345e8139d971ef6ce5af82f632d"
  end

  depends_on "cmake" => :build
  depends_on "corrosion" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  conflicts_with "go-task", because: "both install `task` binaries"

  fails_with gcc: "5"

  # CmdImport.h:41:8: error: no template named 'unordered_map' in namespace 'std'
  # https://github.com/GothenburgBitFactory/taskwarrior/commit/4ff63a796087c9f04f7d6dccd03cda0afdce1f40
  patch :DATA

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install "scripts/bash/task.sh"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system bin/"task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end

__END__
--- a/src/commands/CmdImport.h
+++ b/src/commands/CmdImport.h
@@ -31,6 +31,7 @@
 #include <JSON.h>
 
 #include <string>
+#include <unordered_map>
 
 class CmdImport : public Command {
  public:

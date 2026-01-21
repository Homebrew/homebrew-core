class TaskAT2 < Formula
  desc "Feature-rich console based todo list manager"
  homepage "https://taskwarrior.org/"
  url "https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.2/task-2.6.2.tar.gz"
  sha256 "b1d3a7f000cd0fd60640670064e0e001613c9e1cb2242b9b3a9066c78862cfec"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia:  "f8c1a9cf2878e0f0167b9ec74d1ef1ffb393048efa96309e6c39295e1a83843e"
    sha256                               arm64_sonoma:   "82df1c51fe66c7f8981adea3530dcb68c461a994e4f63eb3010b9478bf66ee76"
    sha256                               arm64_ventura:  "dfbe4a2d59a68aa0a67addcc9ffa8d2fe062f03083f9942c2273617d853e94c3"
    sha256                               arm64_monterey: "289d6b7e6297a61fd798ead189573672163738ff9b48d3f27cfba6bc2e251463"
    sha256                               sonoma:         "d3be3340c35f266904599c9a3927323f02c797cb15c977af12e2f09658c3eb54"
    sha256                               ventura:        "4e3710bd68b073e6bd7053dddeebda5dbbbd263b97314a11bd989cd306ac6fe1"
    sha256                               monterey:       "b7aff94161fa64605d6738d900c671f6d6c56fabdb916669ba2637421b4d8319"
    sha256                               arm64_linux:    "520281ca177683c84f7fda4f0832c59224fdd0df9e0fa6f82cad87a0c788e8e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a1030f03e0e5ec13e4111be5eb28369bf81d84df3690614c422c33ca3076ff7"
  end

  keg_only :versioned_formula

  disable! date: "2025-04-30", because: :unmaintained

  depends_on "cmake" => :build
  depends_on "gnutls"

  on_linux do
    depends_on "linux-headers@5.15" => :build
    depends_on "readline"
    depends_on "util-linux"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "scripts/bash/task.sh" => "task"
    zsh_completion.install "scripts/zsh/_task"
    fish_completion.install "scripts/fish/task.fish"
  end

  test do
    touch testpath/".taskrc"
    system bin/"task", "add", "Write", "a", "test"
    assert_match "Write a test", shell_output("#{bin}/task list")
  end
end

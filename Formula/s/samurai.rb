class Samurai < Formula
  desc "Ninja-compatible build tool written in C"
  homepage "https://github.com/michaelforney/samurai"
  url "https://github.com/michaelforney/samurai/releases/download/1.3/samurai-1.3.tar.gz"
  sha256 "1bc020a9e133432df51911ac71cc34322f828934d9a2282ba2916d88c15976af"
  license "Apache-2.0"
  head "https://github.com/michaelforney/samurai.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aba1f0aaecc11ec62b7efd2fefe64ca540bc3388d9e13c59b9227aef61eb8b5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9239dbde688bc3d1031a14374fb412ccb54539d6d6a333ed5feea64f102d82b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83127de0ba9e6908696bae62865efab78ff3717373c9633d64f0d6e997073498"
    sha256 cellar: :any_skip_relocation, sonoma:        "a894b019efc35acda75a127e0f52bf9b9d334a70556ec245629b546342fabfcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30965d4a7769dadd1ed40f18a36234be72597452f5358ccca7c24ab2ab72beae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94dd3b80ffbddb9853e86dcaf2a8ee4a4031b00eb7a3f9d587cb34c4f9e8aaf"
  end

  # Only link librt on Linux, upstream PR ref, https://github.com/michaelforney/samurai/pull/121
  patch do
    url "https://github.com/michaelforney/samurai/commit/d17ee9ae9448731e7707b4af5824453298ce69d9.patch?full_index=1"
    sha256 "16d65b7857f982085a76d9594ad8899a2b6a2743cb9b8379747cded6facc8dd3"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"build.ninja").write <<~EOS
      rule cc
        command = #{ENV.cc} $in -o $out
      build hello: cc hello.c
    EOS
    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    C
    system bin/"samu"
    assert_match "Hello, world!", shell_output("./hello")
  end
end

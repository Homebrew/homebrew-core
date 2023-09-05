class Stuffbin < Formula
  desc "Compress and embed static files and assets into Go binaries"
  homepage "https://github.com/knadh/stuffbin"
  url "https://github.com/knadh/stuffbin/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7a96e189108d3c5ba437e2d40484cfd4145fd1b6e3d84a798c14197c2a35e3e0"
  license "MIT"
  head "https://github.com/knadh/stuffbin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e29b89cceb2446e9c1aa387638882edabb1cec8b704ec513f95e33c2ba577cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6fc4d0b8c004180ad3ab32f8dd86a00f1ba774e9e1c6a5e04efa2f953b0d516b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b21b4d0ff19720e8c4858204b1b170a8da6fdad94634f1de261777b4e45a6b55"
    sha256 cellar: :any_skip_relocation, ventura:        "2a6e24289acd934a18c075c9f0f2169653468a03693c0bb0f1571ad38b08d783"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0e90411661711f560c0a2876e5855749026ff9e56710bee4dadf8f11794439"
    sha256 cellar: :any_skip_relocation, big_sur:        "613439ea92ed5ef10237bea7853d6a60f0cf043928c0d73907aa72599b207df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b863bc66d0beefde8f4c03ee4c4ec2ea9e7e10f1a96da1d68ab711ce9b4c3429"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./stuffbin"
  end

  test do
    mkdir "brewtest" do
      system "go", "mod", "init", "brewtest"
      system "go", "get", "github.com/knadh/stuffbin"

      (testpath/"brewtest/foo.txt").write "brewfoo"
      (testpath/"brewtest/main.go").write <<~EOS
        package main

        import (
          "log"
          "os"

          "github.com/knadh/stuffbin"
        )

        func main() {
          path, _ := os.Executable()
          fs, _ := stuffbin.UnStuff(path)
          f, _ := fs.Get("foo.txt")
          log.Println("foo.txt =", string(f.ReadBytes()))
        }
      EOS

      system "go", "build", "."
      output = shell_output("#{bin}/stuffbin -a stuff -in brewtest -out brewtest2 foo.txt")
      assert_match "stuffing complete.", output
      assert_match "foo.txt = brewfoo", shell_output("#{testpath}/brewtest/brewtest2 2>&1")

      output = shell_output("#{bin}/stuffbin -a id -in brewtest2")
      assert_match "brewtest2: stuffbin", output
      assert_match "/foo.txt", output
    end
  end
end

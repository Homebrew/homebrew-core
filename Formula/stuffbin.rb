class Stuffbin < Formula
  desc "Compress and embed static files and assets into Go binaries"
  homepage "https://github.com/knadh/stuffbin"
  url "https://github.com/knadh/stuffbin/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "7a96e189108d3c5ba437e2d40484cfd4145fd1b6e3d84a798c14197c2a35e3e0"
  license "MIT"
  head "https://github.com/knadh/stuffbin.git", branch: "master"

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

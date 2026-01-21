class Stuffbin < Formula
  desc "Compress and embed static files and assets into Go binaries"
  homepage "https://github.com/knadh/stuffbin"
  url "https://github.com/knadh/stuffbin/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "10de8bdec2997299beaff857cd5a4c74b3951c9e4dab97b68f7b97af8d564ac3"
  license "MIT"
  head "https://github.com/knadh/stuffbin.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4a5cef2de17c168c387ecd9c6eb0bbc7d224f8514e1523e2d120f496276080f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "402fa14f5eb2b8e670aa9253aa94c89ad8f8153b005b85a9a96060114ff91ef7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "075e2b5c0183fc8210112ffe224dfabd77f082428afa415880092398611c6ee3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a22abd7d6229a8da78e49a7b4b251f3a24bf5a56197ae49c79c467f2b1b23a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc6f9b8cdd0848996baf1d5487adbae3f8c88608af85c4d78f9cdc20f1a2641e"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4702c84d4e3addd0e01a547054d07ec4e275198b01faee3f9abec4357ebc036"
    sha256 cellar: :any_skip_relocation, ventura:        "28b0dddef2ae15146e894ca2259e7d74f14f44c3dcb91d54521673abed67a7c7"
    sha256 cellar: :any_skip_relocation, monterey:       "6b3252e69344f21f6d9876c1ed5d675c7ad7416b1d2834bcdb6a3eb73beb8144"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "642816fb11b7166f67a83ab88504281efac509bb72eeb7167244b6ee8420ec55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65cd393efa034045fa6f6fb9c3a3c376823f6349b70a187055f398d82323351d"
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
      (testpath/"brewtest/main.go").write <<~GO
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
      GO

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

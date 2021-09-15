class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.5.2.tar.gz"
  sha256 "2c42f0b1768a5ca0f9e7fe2241962e6ab54940964d60e2560c67b0029dac7bf1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa384e0623d92232575207c1d393204e05254206e9309b9160be038f698bcb11"
    sha256 cellar: :any_skip_relocation, big_sur:       "508115afcebb6b4fe2b6491652cc386633144cb48669fd4624eb60542fa43fd8"
    sha256 cellar: :any_skip_relocation, catalina:      "95c45f88283b8e8e7a4563440bb9e3ed10f93dfe43eac5e927ae1ebae65dac0b"
    sha256 cellar: :any_skip_relocation, mojave:        "44fc500be24c9cc38b5c7031cf600019083c5385e18bd067eeacb1424061d0c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a674a05a86c284a8f15d82c01e73af0e1802b755659c6417d79157ff2108f82f"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "--no-daemon"

    %w[smali baksmali].each do |name|
      jarfile = "#{name}-#{version}-dev-fat.jar"

      libexec.install "#{name}/build/libs/#{jarfile}"
      bin.write_jar_script libexec/jarfile, name
    end
  end

  test do
    # From examples/HelloWorld/HelloWorld.smali in Smali project repo.
    # See https://bitbucket.org/JesusFreke/smali/src/2d8cbfe6bc2d8ff2fcd7a0bf432cc808d842da4a/examples/HelloWorld/HelloWorld.smali?at=master
    (testpath/"input.smali").write <<~EOS
      .class public LHelloWorld;
      .super Ljava/lang/Object;

      .method public static main([Ljava/lang/String;)V
        .registers 2
        sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
        const-string v1, "Hello World!"
        invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
        return-void
      .end method
    EOS

    system bin/"smali", "assemble", "-o", "classes.dex", "input.smali"
    system bin/"baksmali", "disassemble", "-o", pwd, "classes.dex"
    assert_match "Hello World!", File.read("HelloWorld.smali")
  end
end

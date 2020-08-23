class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.4.0.tar.gz"
  sha256 "6a9014ecffd7d374f1b9e3c236b11d18a8d8f9c33dbb8ca171c79cc243a0f902"
  license "BSD-3-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2a17c236e4dea10abb4cfc8383abd72204dfa925e72ab10bf6aaaa02875af266" => :catalina
    sha256 "39f6422066f4b61496c4ce287f37a7ee1069926eea698a6dbd15a131e14a7616" => :mojave
    sha256 "7b90641feb3ce88a706bee6c8b5ca3a231f4d3c2ce138d7fabe5d470574d77f3" => :high_sierra
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

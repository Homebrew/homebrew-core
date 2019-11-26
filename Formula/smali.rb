class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.3.4.tar.gz"
  sha256 "d364ebb60ac954cac7c974d72def897a373430fcd4e3349816743147fbaba375"
  revision 1

  depends_on "gradle" => :build
  depends_on :java => "1.8+"

  def install
    system "gradle", "build", "--no-daemon"

    %w[smali baksmali].each do |name|
      jarfile = "#{name}-#{version}-dev-fat.jar"

      libexec.install "#{name}/build/libs/#{jarfile}"
      bin.write_jar_script libexec/jarfile, name, :java_version => "1.8+"
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

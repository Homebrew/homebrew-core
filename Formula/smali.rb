class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://github.com/JesusFreke/smali/archive/v2.4.0.tar.gz"
  sha256 "6a9014ecffd7d374f1b9e3c236b11d18a8d8f9c33dbb8ca171c79cc243a0f902"

  bottle do
    cellar :any_skip_relocation
    sha256 "d1c7681f60d45b5f7136c0c7d2c5a83c7bf633e8b804b05bf0ae03d54e771718" => :catalina
    sha256 "261b6ac2d6ec76698c3d5412774297a997e915bbff7428a3dcba894e4ff6dbac" => :mojave
    sha256 "653de129bfac3a35e0b32dc84c934e8058ee9ba40c0a42a1bf9c3c7ed5ffdb09" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    system "gradle", "build", "--no-daemon"

    %w[smali baksmali].each do |name|
      jarfile = "#{name}-#{version}-dev-fat.jar"

      libexec.install "#{name}/build/libs/#{jarfile}"

      (bin/name).write <<~EOS
        #!/bin/bash
        export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
        exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/#{jarfile}" "$@"
      EOS
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

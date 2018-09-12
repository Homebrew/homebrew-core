class Smali < Formula
  desc "Assembler/disassembler for Android's Java VM implementation"
  homepage "https://github.com/JesusFreke/smali"
  url "https://bitbucket.org/JesusFreke/smali/downloads/smali-2.2.5.jar"
  sha256 "7bd1677594b917f6c538b7ac7e8958294a94ec95e99efecda5aee935060138b6"

  bottle :unneeded

  resource "baksmali-jar" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali-2.2.5.jar"
    sha256 "e12c5c9c140ee63487037ad8dc6d5ebd43c0185e1a56524f554d0a845240ec06"
  end

  resource "baksmali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/baksmali"
    sha256 "5d4b79776d401f2cbdb66c7c88e23cca773b9a939520fef4bf42e2856bbbfed4"
  end

  resource "smali" do
    url "https://bitbucket.org/JesusFreke/smali/downloads/smali"
    sha256 "910297fbeefb4590e6bffd185726c878382a0960fb6a7f0733f045b6faf60a30"
  end

  def install
    resource("baksmali-jar").stage do
      libexec.install "baksmali-#{version}.jar" => "baksmali.jar"
    end

    libexec.install "smali-#{version}.jar" => "smali.jar"

    %w[smali baksmali].each do |r|
      libexec.install resource(r)
      inreplace libexec/r, /^libdir=.*$/, "libdir=\"#{libexec}\""
      chmod 0755, libexec/r
      bin.install_symlink libexec/r
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

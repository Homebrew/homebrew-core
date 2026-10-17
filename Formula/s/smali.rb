class Smali < Formula
  desc "Assembler and disassembler for the Android DEX format"
  homepage "https://github.com/google/smali"
  url "https://github.com/google/smali/archive/refs/tags/3.0.10.tar.gz"
  sha256 "faaa812184f90eebf7ce3026f13371f544a254652f690b2dfbe2fdb21e8b5d29"
  license "BSD-3-Clause"

  depends_on "gradle@8" => :build
  depends_on "openjdk"

  allow_network_access! :build

  def install
    system "gradle", "--no-daemon", "smali:fatJar", "baksmali:fatJar"

    libexec.install buildpath.glob("{smali,baksmali}/build/libs/*-fat.jar")
    bin.write_jar_script libexec/"smali-#{version}-fat.jar", "smali"
    bin.write_jar_script libexec/"baksmali-#{version}-fat.jar", "baksmali"
  end

  test do
    (testpath/"Hello.smali").write <<~EOS
      .class public LHello;
      .super Ljava/lang/Object;

      .method public static main([Ljava/lang/String;)V
          .registers 1
          return-void
      .end method
    EOS

    system bin/"smali", "assemble", "-o", testpath/"classes.dex", testpath/"Hello.smali"
    assert_path_exists testpath/"classes.dex"
    assert_operator (testpath/"classes.dex").size, :>, 0
    shell_output("#{bin}/baksmali disassemble -o #{testpath}/out #{testpath}/classes.dex")
    assert_path_exists testpath/"out/Hello.smali"
    assert_match "main([Ljava/lang/String;)V", (testpath/"out/Hello.smali").read
  end
end

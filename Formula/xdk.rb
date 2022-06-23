class Xdk < Formula
  desc "Ecstasy Development Kit (XDK)"
  homepage "https://github.com/xtclang/xvm/"
  url "https://github.com/xtclang/xvm/releases/download/v0.4.2/xdk-0.4.2.tar.gz"
  sha256 "b0b5217abf05de986e6211a7c8665b304fa89df1726749e4f1dd7eff1cbbe1fe"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    %w[doc examples javatools lib README.md].each do |child_name|
      libexec.install buildpath/child_name
    end
    libexecbin = libexec + "bin"
    libexecbin.mkdir
    %w[xec xtc xam].each do |cmd|
      java   = "${JAVA_HOME}/bin/java"
      args   = "-Xms256m -Xmx1024m -ea -jar #{libexec}/javatools/javatools.jar" \
               " #{cmd} -L #{libexec}/lib -L #{libexec}/javatools"
      cmd_sh = libexecbin + cmd
      cmd_sh.write <<~SH
        #!/bin/bash
        export JAVA_HOME="#{Language::Java.overridable_java_home_env[:JAVA_HOME]}"
        exec "#{java}" #{args} "$@"
      SH
      cmd_sh.chmod 0755
      bin.install_symlink cmd_sh => cmd
    end
  end

  test do
    src_file = testpath + "HelloWorld.x"
    obj_file = testpath + "HelloWorld.xtc"
    src_file.write <<~SF
      module HelloWorld
          {
          void run()
              {
              @Inject Console console;
              console.println("Hello World!");
              }
          }
    SF
    system "#{bin}/xtc #{src_file}"
    assert_match "Hello World!", shell_output("#{bin}/xec #{obj_file} 2>&1")
  end
end

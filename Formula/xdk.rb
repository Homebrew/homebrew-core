class Xdk < Formula
  desc "Ecstasy Development Kit (XDK)"
  homepage "https://github.com/xtclang/xvm/"
  url "https://github.com/xtclang/xvm/releases/download/v0.4.2/xdk-0.4.2.tar.gz"
  sha256 "b0b5217abf05de986e6211a7c8665b304fa89df1726749e4f1dd7eff1cbbe1fe"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.install buildpath.children
    %w[xec xtc xam].each do |cmd|
      java = "${JAVA_HOME}/bin/java"
      args = "-Xms256m -Xmx1024m -ea -jar #{libexec}/javatools/javatools.jar" \
             " #{cmd} -L #{libexec}/lib -L #{libexec}/javatools"
      (bin/cmd).write_env_script java, args, Language::Java.overridable_java_home_env
    end
  end

  test do
    system "#{bin}/xec", "-help"
  end
end

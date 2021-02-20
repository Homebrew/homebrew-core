class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v2.0.0/ringojs-2.0.0.tar.gz"
  sha256 "5991953012f3c493abb8c7256fa48e885bd284976bd1ec36f20fef77ff37fac9"
  license "Apache-2.0"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    env = { RINGO_HOME: libexec }
    env.merge! Language::Java.overridable_java_home_env
    bin.env_script_all_files libexec/"bin", env
  end

  test do
    (testpath/"test.js").write <<~EOS
      var x = 40 + 2;
      console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end

class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v1.1.1/ringojs-1.1.1.tar.gz"
  sha256 "6ac2687f85e1acc48ab9f9528a64ff2895d787ff303f44aad6906de25af55498"

  bottle :unneeded

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<~EOS
        var x = 40 + 2;
        console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end

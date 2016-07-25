class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "http://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v0.12.0/ringojs-0.12.tar.gz"
  sha256 "1ec1a325d94bcb8512cd9e8e972525c34dd5871bbad92689f00efdfc109ba668"

  bottle :unneeded

  def install
    rm Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write <<-EOS.undent
        var x = 40 + 2;
        console.assert(x === 42);
    EOS
    system "#{bin}/ringo", "test.js"
  end
end

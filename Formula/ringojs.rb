class Ringojs < Formula
  desc "CommonJS-based JavaScript runtime"
  homepage "https://ringojs.org"
  url "https://github.com/ringo/ringojs/releases/download/v1.0.0/ringojs-1.0.0.tar.gz"
  sha256 "e899028e6d0c27d7069d5664887fc36e365d26143b3cd048efcbdd5434484246"

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

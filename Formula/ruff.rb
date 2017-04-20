class Ruff < Formula
  desc "IoT platform with JavaScript as application language"
  homepage "https://ruff.io"
  url "http://sdk.ruff.io/ruff-sdk-mac-1.5.0.zip"
  sha256 "764e8d84ce7d8b31d41867b038538564f1b8ecd2a9eae8e8e3a79040a351fd4b"

  def install
    prefix.install Dir["*"]
  end

  test do
    (testpath/"ruff-test.js").write <<-EOS.undent
      console.log("hello, Ruff")
    EOS
    system "#{bin}/ruff", testpath/"ruff-test.js"
  end
end

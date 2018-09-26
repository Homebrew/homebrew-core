class Wkhtmltopdf < Formula
  desc "Command-line tools to render HTML into PDF and various image formats"
  homepage "https://wkhtmltopdf.org/"
  version "0.12.5"
  url "https://downloads.wkhtmltopdf.org/#{version.to_s.split(".")[0]}.#{version.to_s.split(".")[1]}/#{version}/wkhtmltox-#{version}-1.macos-cocoa.pkg"
  sha256 "2718c057249a133fe413b3c8cfb33b755a2e18a8e233329168f1af462cd6de5f"

  def install
    major, minor, = version.to_s.split(".")
    system "pkgutil", "--expand-full", "wkhtmltox-#{version}-1.macos-cocoa.pkg", "pkg"
    system "tar", "xzf", "pkg/Payload/usr/local/share/wkhtmltox-installer/wkhtmltox.tar.gz"

    bin.install "bin/wkhtmltoimage", "bin/wkhtmltopdf"
    include.install "include/wkhtmltox"
    lib.install "lib/libwkhtmltox.dylib", "lib/libwkhtmltox.#{major}.dylib", "lib/libwkhtmltox.#{major}.#{minor}.dylib"
    lib.install "lib/libwkhtmltox.#{version}.dylib"
    man1.install "share/man/man1/wkhtmltoimage.1.gz", "share/man/man1/wkhtmltopdf.1.gz"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <html><body>Test File</body></html>
    EOS

    system "#{bin}/wkhtmltopdf", "test.html", "test.pdf"
    output = shell_output("file test.pdf")
    assert_match /PDF document/, output
  end
end

class Xmlsectool < Formula
  desc "Check well-formedness, schema validity, and signature of an XML document."
  homepage "https://wiki.shibboleth.net/confluence/display/XSTJ2/xmlsectool+V2+Home"
  url "https://shibboleth.net/downloads/tools/xmlsectool/latest/xmlsectool-2.0.0-bin.zip"
  sha256 "83ea1e977d947dd5f2f5600a3280bc5d372a4913f0dbce1ddf2c0ca1c869ca57"

  depends_on :java => "1.7+"

  def install
    rm_rf "doc"
    prefix.install_metafiles
    libexec.install Dir["*"]
    # temp workaround
    inreplace "#{libexec}/xmlsectool.sh", "LOCATION=$0", "LOCATION=#{libexec}/"
    bin.install_symlink "#{libexec}/xmlsectool.sh" => "xmlsectool"
  end

  test do
    system bin/"xmlsectool", "--listBlacklist"
  end
end

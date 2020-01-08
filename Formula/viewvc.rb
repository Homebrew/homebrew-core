class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.1.27/viewvc-1.1.27.tar.gz"
  sha256 "f5def1dda61568b468c608a0805fe73c15c2073b263cb5395de96ad3218973a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0157860001cda22491da3389179f69e3a13f6edb9d525d64c48e09360c5bbe9d" => :catalina
    sha256 "a42a0ce05dbc1e36a8a1a75e4b16fe22a5c7501c54f0459283c1d112aedd3644" => :mojave
    sha256 "a42a0ce05dbc1e36a8a1a75e4b16fe22a5c7501c54f0459283c1d112aedd3644" => :high_sierra
    sha256 "abc850e402813a1208bfff6f59b82ed8bc695d3e192b72cbb9873f50a1200c30" => :sierra
  end

  depends_on "subversion"

  def install
    system "python", "./viewvc-install", "--prefix=#{libexec}", "--destdir="
    Pathname.glob(libexec/"bin/*") do |f|
      next if f.directory?

      bin.install_symlink f => "viewvc-#{f.basename}"
    end
  end

  test do
    require "net/http"
    require "uri"

    begin
      pid = fork { exec "#{bin}/viewvc-standalone.py", "--port=9000" }
      sleep 2
      uri = URI.parse("http://127.0.0.1:9000/viewvc")
      Net::HTTP.get_response(uri) # First request always returns 400
      assert_equal "200", Net::HTTP.get_response(uri).code
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end

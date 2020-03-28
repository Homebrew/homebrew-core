class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.2.1/viewvc-1.2.1.tar.gz"
  sha256 "afbc2d35fc0469df90f5cc2e855a9e99865ae8c22bf21328cbafcb9578a23e49"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e4e8185a678846f8a70254a737166aca533ccb6604a116f59a2e1ae43ba3176" => :catalina
    sha256 "5308cdd92703103eb52482215269d3d6df53689908701ecd204120b533e1512b" => :mojave
    sha256 "5308cdd92703103eb52482215269d3d6df53689908701ecd204120b533e1512b" => :high_sierra
  end

  depends_on "subversion"

  # https://github.com/viewvc/viewvc/issues/138
  uses_from_macos "python@2" # does not support Python 3

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

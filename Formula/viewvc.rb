class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.1.26/viewvc-1.1.26.tar.gz"
  sha256 "9d718237df7fc04d511302812c0bec0363cf6b8334ab796953a764c2de426e43"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d9768a4c14c2c7cf7a8318b1b5ed4b6a2e74702b1018402e6e454e2df05bc0f1" => :mojave
    sha256 "dd3b0a77e2eb08bbec7f5a0b14744f2dcc7894d4da9702d1e489e901c8e9a4f0" => :high_sierra
    sha256 "dd3b0a77e2eb08bbec7f5a0b14744f2dcc7894d4da9702d1e489e901c8e9a4f0" => :sierra
    sha256 "dd3b0a77e2eb08bbec7f5a0b14744f2dcc7894d4da9702d1e489e901c8e9a4f0" => :el_capitan
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

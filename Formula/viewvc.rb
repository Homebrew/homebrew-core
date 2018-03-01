class Viewvc < Formula
  desc "Browser interface for CVS and Subversion repositories"
  homepage "http://www.viewvc.org"
  url "https://github.com/viewvc/viewvc/releases/download/1.1.26/viewvc-1.1.26.tar.gz"
  sha256 "9d718237df7fc04d511302812c0bec0363cf6b8334ab796953a764c2de426e43"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a9a0b010a04b5af7a33c372dab11fa249b02fb6eea4ea583eda4af3730394eda" => :high_sierra
    sha256 "d692c6f47134e21a0e0659ee854cb8ad6ed8e45bc88b0bcbaf3307e7fba24d1b" => :sierra
    sha256 "cb3b467bbb5268c62e3ab2cc1870000fce3558e3443b33bb6fa17c2ce87147cc" => :el_capitan
    sha256 "cb3b467bbb5268c62e3ab2cc1870000fce3558e3443b33bb6fa17c2ce87147cc" => :yosemite
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

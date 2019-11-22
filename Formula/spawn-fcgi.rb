class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "a0665cd25e441b8f798073125e2f4151588aed54408b17f894e62a353ca73d47" => :catalina
    sha256 "2512789a14b629470c684a4694e7f26fb28a9734b156f0756279bc8f40c2f2bd" => :mojave
    sha256 "31c9d255c30ac65009b0972c7b9fe8a8835f8c305800c1b147471b44113fd285" => :high_sierra
    sha256 "23140d56da75279d033d123b5cc5a7d50018dd08e6c74e3ed118eac5adbac555" => :sierra
    sha256 "4e6f999ebcad8b7ce84473379b6358ec569559f9e4b772d31ef1a5b0e01fc865" => :el_capitan
    sha256 "7473e3e2cd5322b2f09011e2b5119622e145d136cd0a8d4ce7adcb255a13d83b" => :yosemite
    sha256 "a19a14cae6fbacdc5aa1a8132f5d290743ba7385c2d76903dbd172ca07b38680" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spawn-fcgi", "--version"
  end
end

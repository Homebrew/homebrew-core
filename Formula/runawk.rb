class Runawk < Formula
  desc "Powerful wrapper for AWK interpreter"
  homepage "https://github.com/cheusov/runawk"
  url "https://sourceforge.net/projects/runawk/files/runawk/runawk-1.6.0/runawk-1.6.0.tar.gz"
  sha256 "51461587ab0acb12994cc6de766ec4594f57cd49efea9d67a7a400628c41555f"

  depends_on "mk-configure" => :build

  def install
    ENV["PREFIX"] = "#{prefix}"
    
    system "mkcmake", "all", "examples"
    system "mkcmake", "install", "install-examples"
  end

  test do
    system "runawk", "-V"
  end
end

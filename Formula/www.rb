class Www < Formula
    desc "HTTPS? static web server"
    homepage "https://github.com/nbari/www"
    url "https://github.com/nbari/www.git",
        :tag => "1.1.1",
        :revision => "88e655e483e714d45fdcca1a5054c69d04cab75c"
  
    head "https://github.com/nbari/www.git"
  
    depends_on "go" => :build
    depends_on "dep" => :build
  
    def install
      ENV["GOPATH"] = buildpath
      (buildpath/"src/github.com/nbari/www").install buildpath.children
      cd "src/github.com/nbari/www" do
        system "dep", "ensure"
        ldflags = "-s -w"
        system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/www"
        prefix.install_metafiles
      end
    end
  
    test do
      system bin/"www", "-h"
    end
  end
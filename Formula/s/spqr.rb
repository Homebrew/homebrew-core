class Spqr < Formula
    desc "A project for creating Go projects using hexagonal architecture easily and simply"
    homepage "https://github.com/spqr-go/spqr"
    url "https://github.com/spqr-go/spqr/releases/download/spqr/spqr"
    sha256 "4848df26b2c33d6f263ecbe841cc8b0e627537b0c281abb3fc2235e6125c7704"
    version "0.1.0"  
  
    def install
      bin.install "spqr"
    end
  
    test do
      system "#{bin}/spqr", "--version"
    end
  end
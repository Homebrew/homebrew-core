class Wsjcpp < Formula
    desc "Yet one... C++ Package Manager"
    homepage "https://github.com/wsjcpp/wsjcpp"
    version "v0.1.1"
    url "https://github.com/wsjcpp/wsjcpp/archive/v0.1.1.tar.gz"
    sha256 "cf484645f3d857201a4e3302abbfd32bb1a61534cef262a0882902df4d99e58c"
    head "https://github.com/wsjcpp/wsjcpp.git", :branch => "master"
  
    depends_on "cmake"
    depends_on "curl-openssl"
    depends_on "pkg-config"
    depends_on :xcode
    
    bottle do
        cellar :any
        rebuild 1
    end
    
    def install
        bin.mkpath
        system "cmake", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}" , "."
        system "make"
        system "cp", "./wsjcpp", "#{prefix}/bin/wsjcpp"
        bin.install_symlink
    end

    test do
        system bin/"wsjcpp", "version"
    end
  end

class Seexpr < Formula
  desc "Embeddable expression evaluation engine"
  homepage "https://www.disneyanimation.com/technology/seexpr.html"
  url "https://github.com/wdas/SeExpr/archive/v3.0.1.tar.gz"
  sha256 "1e4cd35e6d63bd3443e1bffe723dbae91334c2c94a84cc590ea8f1886f96f84e"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "2a55400ad86255b300843f7cde1dbed4130d0ba26ffc4c8725fec83b50e7f9e3" => :catalina
    sha256 "e5ba2fcca24837fc43d11524fdeff04d9f4429f6c66421dec6c1925b60893f82" => :mojave
    sha256 "b5a3d64c08f692d25d3eb12dd9409c414939303b0b9f19396c95a13d07b46fa9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libpng"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DUSE_PYTHON=FALSE"
      system "make", "doc"
      system "make", "install"
    end
  end

  test do
    assert_equal shell_output("#{bin}/asciigraph2"), <<~EOS
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                   ###                            
                                  # |#                            
                                 ## |##                           
                                 #  | #                           
                                ##  | ##                          
                                #   |  #                          
                               ##   |  ##                         
                               #    |   #                         
                               #    |   ##                        
                   ####       #     |    #       ####             
      #######-----##--###-----#-----|----##-----##--###-----######
            ######      ##   #      |     #    #      ######      
                         ## ##      |     ## ##                   
                          ###       |      ###                    
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
                                    |                             
    EOS
  end
end

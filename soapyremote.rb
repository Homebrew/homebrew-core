class Soapyremote < Formula
  desc "SoapySDR Remote Support Module"
  homepage "https://github.com/pothosware/SoapyRemote/wiki"
  url "https://github.com/pothosware/SoapyRemote/archive/soapy-remote-0.5.2.tar.gz"
  sha256 "66a372d85c984e7279b4fdc0a7f5b0d7ba340e390bc4b8bd626a6523cd3c3c76"
  license "BSL-1.0"
  head "https://github.com/pothosware/SoapyRemote.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "soapysdr"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    assert_match "Checking driver 'remote'... PRESENT",
                 shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=remote")
  end
end

class Ydict < Formula
  desc "Yet another command-line dictionary for geeks!"
  homepage "https://github.com/TimothyYe/ydict"
  url "https://github.com/TimothyYe/ydict/releases/download/V0.6/ydict-mac64-0.6.tar.gz"
  sha256 "8596ca84cee14975a83645f8aa3529ff47e26d939ba9521b95170dc13471c2e3"

  def install
    bin.install "ydict"
  end

  test do
    system "#{bin}/ydict", "hello"
  end
end

class ServalDna < Formula
  desc "Serval is an open-source, delay-tolerant networking system."
  homepage "http://www.servalproject.org"
  url "https://github.com/servalproject/serval-dna/archive/c78ee668d5a08ca4f528a4260de384aaa2a06fed.tar.gz"
  version "batphone-release-0.93"
  sha256 "314b50bf0f45c6a4ff118a3f8b0d305e15c234bdb773bf505152689e9428e0b3"
  head "https://github.com/servalproject/serval-dna.git", :branch => "development"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-f", "-i", "-I", "m4"
    system "./configure"
    File.write("#{buildpath}/VERSION.txt", "#{version}\n")
    system "make", "servald"
    bin.install "servald"
  end

  test do
    system "#{bin}/servald", "version"
  end
end

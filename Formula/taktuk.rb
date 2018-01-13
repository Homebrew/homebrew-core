class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "http://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/file/37055/taktuk-3.7.7.tar.gz"
  sha256 "56a62cca92670674c194e4b59903e379ad0b1367cec78244641aa194e9fe893e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "dd847ab64b86ca67c4c2736ccb3534fef03c2aaeea031d06d841664d4f9b1d73" => :high_sierra
    sha256 "236b1b7277a6ff6e33bab7818cb779f32f1415e3e51e4edda6f243499328d1e5" => :sierra
    sha256 "b5f260c944e09210f94a3b215112ed2975bf9c4a93ad1fdd30a627700e48a364" => :el_capitan
    sha256 "4f703e2c8fb0f1b5c4c8b19b6a42e3a14023b40d6c511a10e0d460b8810d629e" => :yosemite
    sha256 "b0ca7976fb797a3d74c4e97d26214f6b7fdd6cf6764cd9fc3d0f2b3931479bd5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    system "#{bin}/taktuk", "quit"
  end
end

class Taktuk < Formula
  desc "Deploy commands to (a potentially large set of) remote nodes"
  homepage "http://taktuk.gforge.inria.fr/"
  url "https://gforge.inria.fr/frs/download.php/30903/taktuk-3.7.5.tar.gz"
  sha256 "62d1b72616a1b260eb87cecde2e21c8cbb844939f2dcafad33507fcb16ef1cb1"

  bottle do
    cellar :any
    rebuild 1
    sha256 "236b1b7277a6ff6e33bab7818cb779f32f1415e3e51e4edda6f243499328d1e5" => :sierra
    sha256 "b5f260c944e09210f94a3b215112ed2975bf9c4a93ad1fdd30a627700e48a364" => :el_capitan
    sha256 "4f703e2c8fb0f1b5c4c8b19b6a42e3a14023b40d6c511a10e0d460b8810d629e" => :yosemite
    sha256 "b0ca7976fb797a3d74c4e97d26214f6b7fdd6cf6764cd9fc3d0f2b3931479bd5" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.j1
    system "make", "install"
  end

  test do
    system "#{bin}/taktuk", "quit"
  end
end

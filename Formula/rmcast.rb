class Rmcast < Formula
  desc "IP Multicast library"
  homepage "http://www.land.ufrj.br/tools/rmcast/rmcast.html"
  url "http://www.land.ufrj.br/tools/rmcast/download/rmcast-2.0.0.tar.gz"
  sha256 "79ccbdbe4a299fd122521574eaf9b3e2d524dd5e074d9bc3eb521f1d934a59b1"

  livecheck do
    url :homepage
    regex(/href=.*?rmcast[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "7edab23a8770a245b0f06197b2d46c4777b8fdac0f39842ce619c56d74f1eef4"
    sha256 cellar: :any,                 big_sur:       "b2cc007eec98b5e422a7948e9e680f3a0d7c622eb4703f9b2bae6c867635107f"
    sha256 cellar: :any,                 catalina:      "e2054828627f6afdd376cfd276536c770b8dd77b082a44c5b63212e8dff84351"
    sha256 cellar: :any,                 mojave:        "37226d25db0ae3fe7491c530e1f382b869d134d7e38a851acfbe13cb308f7c1d"
    sha256 cellar: :any,                 high_sierra:   "d30e495d583d02a5ea74cd7ec82d1bd67b62981248d853ce7138a7997f6b6ed2"
    sha256 cellar: :any,                 sierra:        "9ef73c5d52886029cd89d829cdceccca0d03bce0dc72647d8cce6704d492f080"
    sha256 cellar: :any,                 el_capitan:    "4fe0a1745659bb99748972c2fa0640e6b864e92739ba192a89ed12c0614b1372"
    sha256 cellar: :any,                 yosemite:      "502e09994a9b455d9040f8e346419a2a3ef0156a73b0249bc161446448729292"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecbaa8a68d7cb766021fb1f1bff97c911a5e16720508cf71648c6e96a2b93c4f"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

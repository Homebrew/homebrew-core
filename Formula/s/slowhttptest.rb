class Slowhttptest < Formula
  desc "Simulates application layer denial of service attacks"
  homepage "https://github.com/shekyan/slowhttptest"
  url "https://github.com/shekyan/slowhttptest/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "a3910b9b844e05ee55838aa17beddc6aa9d6c5c0012eab647a21cc9ccd6c8749"
  license "Apache-2.0"
  head "https://github.com/shekyan/slowhttptest.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "1ba7cafb59ed4524e48d4239aa70aeb822b4788deeb85b38909e568416b908f3"
    sha256 cellar: :any,                 arm64_sequoia: "d36b04a9ac4e272cf5948d94f53aff869382d006110c9cc326610fece68ea7a7"
    sha256 cellar: :any,                 arm64_sonoma:  "22b23a0784dfdf145d60d62a8dae8e1e7c59c22963da6574f4b506b07d6803fb"
    sha256 cellar: :any,                 sonoma:        "032869712d088861b12d6cc9ce2fd12f4c40aaeadb5077201066526517b04e38"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf68abd4a416c7ddef4e1ae4738ac24c66a9a53e50d7a308373fea3c26d2693a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97645f80bc0d31375ee2f451f7d99657a55b46d63baac8b46ab8a4facfc9674a"
  end

  depends_on "openssl@4"

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"slowhttptest", "-u", "https://google.com",
                                  "-p", "1", "-r", "1", "-l", "1", "-i", "1"

    assert_match version.to_s, shell_output("#{bin}/slowhttptest -h", 1)
  end
end

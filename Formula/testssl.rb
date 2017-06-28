class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.8.tar.gz"
  sha256 "76c1b21fcbaa4e625b77c9a9c7a137a2272cd84d07911fb213101aa6b9ce8cfa"
  revision 1

  head "https://github.com/drwetter/testssl.sh.git"

  bottle :unneeded

  depends_on "openssl"

  def install
    ENV.prepend_create_path "PATH", Formula["openssl"].opt_prefix.to_s
    bin.install "testssl.sh"
    bin.env_script_all_files(libexec+"bin", :PATH => ENV["PATH"])
  end

  test do
    system "#{bin}/testssl.sh", "--local"
  end
end

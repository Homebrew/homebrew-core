class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.8.tar.gz"
  sha256 "2e4588bfcd5f4e6b30b2e250d51b39e4209131a5366f1e75354aaa4a5ee6a22d"

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

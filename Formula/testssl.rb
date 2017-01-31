class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.8rc3.tar.gz"
  version "2.8rc3"
  sha256 "e36a60acc0aa09191ff2f86762cd07925630df82498d48d81d86e3b7402a3312"

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

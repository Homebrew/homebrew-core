class Testssl < Formula
  desc "Tool which checks for the support of TLS/SSL ciphers and flaws"
  homepage "https://testssl.sh/"
  url "https://github.com/drwetter/testssl.sh/archive/v2.9.5.tar.gz"
  sha256 "3cd2d14b9b324545ff91d63e4261113f6ff0c6e32232cf49438b9fd2f3c8de3e"
  head "https://github.com/drwetter/testssl.sh.git"

  bottle :unneeded

  depends_on "openssl"

  def install
    ENV.prepend_create_path "PATH", Formula["openssl"].opt_prefix.to_s
    bin.install "testssl.sh"
    bin.env_script_all_files(libexec+"bin", :PATH => ENV["PATH"])
  end

  test do
    system "#{bin}/testssl.sh", "--local", "--warnings", "off"
  end
end

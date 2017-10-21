class Sshrc < Formula
  desc "Bring your .bashrc, .vimrc, etc. with you when you SSH"
  homepage "https://github.com/Russell91/sshrc"
  url "https://github.com/Russell91/sshrc/archive/0.6.1.tar.gz"
  sha256 "e849ff19319381548011a9bdf1e33abc6eba3dc6a910c4226e6981d75d5564dd"

  head "https://github.com/Russell91/sshrc.git"

  bottle :unneeded

  def install
    bin.install %w[sshrc moshrc]
  end

  test do
    touch testpath/".sshrc"
    (testpath/"ssh").write <<~EOS
      #!/bin/sh
      true
    EOS
    chmod 0755, testpath/"ssh"
    ENV.prepend_path "PATH", testpath
    system "#{bin}/sshrc"
  end
end

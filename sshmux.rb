class Sshmux < Formula
  desc "Persistent ssh sessions with tmux and screen"
  homepage "https://github.com/Russell91/sshmux"
  url "https://github.com/Russell91/sshmux/archive/0.1.tar.gz"
  sha256 "7ac0ec6e94a34facc5472bbbdb17ef70c0d2989e2f277ed71325ff36c0bde9a4"

  head do
    url "https://github.com/Russell91/sshmux.git"
  end

  def install
    bin.install "sshmux", "sshscreen/sshscreen"
  end

  test do
    assert_equal "ssh: Could not resolve hostname *illegal_host*: nodename nor servname provided, or not known", shell_output("#{bin}/sshmux *illegal_host*", 1).strip
  end
end

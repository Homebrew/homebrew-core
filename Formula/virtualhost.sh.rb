class VirtualhostSh < Formula
  desc "Script for macOS to create Apache virtual hosts"
  homepage "https://github.com/virtualhost/virtualhost.sh"
  url "https://github.com/virtualhost/virtualhost.sh/archive/1.35.tar.gz"
  sha256 "75d34b807e71acd253876c6a99cdbc11ce31ffb159155373c83a99af862fffcc"
  head "https://github.com/virtualhost/virtualhost.sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "69fa9f84d063cdb79b54c2e198110a9ee786851f8ff9174e43a2565ccd5fbc7e"
  end

  def install
    bin.install "virtualhost.sh"
  end
end

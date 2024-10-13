class Shellshare < Formula
  desc "Live Terminal Broadcast"
  homepage "https://shellshare.net"
  url "https://github.com/vitorbaptista/shellshare/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "0a102c863f60402ab48908563edde38450add0ae02454360fa94065824a61907"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cc656c34170ea6d6e3b9573a0077403840e9a84e9ea764d6e4add6ad9397f9e2"
  end

  def install
    bin.install "public/bin/shellshare"
  end

  test do
    system bin/"shellshare", "-v"
  end
end

class Retry < Formula
  desc "Repeat a command until the command succeeds"
  homepage "https://github.com/minfrin/retry"
  url "https://github.com/minfrin/retry/releases/download/retry-1.0.6/retry-1.0.6.tar.bz2"
  sha256 "b5bbdaee16436fabae608fbc58f47df9726b87b945c9eca1524648500b9afdf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77c76b42cc0cf87c1df0336f794ed29b0daf828d3c43dc2465df8936260f2040"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b67d9e7e3b419a6369f651a9eea7c56342004e9aecfea372c8551fd024a45b97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91d9191c2224348d123ab4b8e5763ec2337c4846f3d8d391aba99bbe3a6c9898"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7ef82f7765062f44a5ff5b4ba8bee756c3e55d380bc0b0b99622f78b7740ce3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c3f927459a0efd10619ecf2b412a1380c148dcc796e9f9e7e174eb0499fdc12"
    sha256 cellar: :any_skip_relocation, ventura:       "7f24158fe4cccb03dca7bc286df3744f4fbabf78cf2af266d3269a31e06466a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e11ae4779ffb1e810dea7f628d0820ed8ee798b268441bdcc3f12baee7deec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "259bb647677bf0520f8341216056f6e6f1be2cddacc822b729932f38f9449d74"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    require "socket"
    port = free_port
    args = %W[--delay 1 --until 0,28 -- curl --max-time 1 telnet://localhost:#{port}]
    Open3.popen2e(bin/"retry", *args) do |_, stdout_and_stderr|
      sleep 3
      assert_match "curl returned 7", stdout_and_stderr.read_nonblock(1024)

      TCPServer.open(port) do |server|
        session = server.accept
        session.puts "Hello world!"
        session.close
      end

      assert_match "Hello world!", stdout_and_stderr.read
    end
  end
end
